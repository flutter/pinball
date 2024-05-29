// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    Component child, {
    PinballAudioPlayer? pinballAudioPlayer,
    PlungerCubit? plungerBloc,
  }) async {
    final parent = Component();
    await ensureAdd(parent);
    return parent.ensureAdd(
      FlameProvider<PinballAudioPlayer>.value(
        pinballAudioPlayer ?? _MockPinballAudioPlayer(),
        children: [
          FlameBlocProvider<PlungerCubit, PlungerState>.value(
            value: plungerBloc ?? PlungerCubit(),
            children: [child],
          ),
        ],
      ),
    );
  }
}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockPlungerCubit extends Mock implements PlungerCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('PlungerNoiseBehavior', () {
    late PinballAudioPlayer audioPlayer;

    setUp(() {
      audioPlayer = _MockPinballAudioPlayer();
    });

    test('can be instantiated', () {
      expect(
        PlungerNoiseBehavior(),
        isA<PlungerNoiseBehavior>(),
      );
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final behavior = PlungerNoiseBehavior();
        await game.pump(behavior);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<PlungerNoiseBehavior>(),
          isNotEmpty,
        );
      },
    );

    flameTester.testGameWidget(
      'plays the correct sound when released',
      setUp: (game, _) async {
        final plungerBloc = _MockPlungerCubit();
        final streamController = StreamController<PlungerState>();
        whenListen<PlungerState>(
          plungerBloc,
          streamController.stream,
          initialState: PlungerState.pulling,
        );

        final behavior = PlungerNoiseBehavior();
        await game.pump(
          behavior,
          pinballAudioPlayer: audioPlayer,
          plungerBloc: plungerBloc,
        );
        streamController.add(PlungerState.releasing);
      },
      verify: (game, _) async {
        game.update(0);

        verify(() => audioPlayer.play(PinballAudio.launcher)).called(1);
      },
    );
  });
}
