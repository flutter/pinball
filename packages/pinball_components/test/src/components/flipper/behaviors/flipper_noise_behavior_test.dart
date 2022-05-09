// ignore_for_file: avoid_dynamic_calls, cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
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
    FlipperNoiseBehavior behavior, {
    FlipperCubit? flipperBloc,
    PinballAudioPlayer? audioPlayer,
  }) async {
    final flipper = Flipper.test(side: BoardSide.left);
    await ensureAdd(
      FlameProvider<PinballAudioPlayer>.value(
        audioPlayer ?? _MockPinballAudioPlayer(),
        children: [
          flipper,
        ],
      ),
    );
    await flipper.ensureAdd(
      FlameBlocProvider<FlipperCubit, FlipperState>.value(
        value: flipperBloc ?? FlipperCubit(),
        children: [behavior],
      ),
    );
  }
}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockFlipperCubit extends Mock implements FlipperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(_TestGame.new);

  group('FlipperNoiseBehavior', () {
    test('can be instantiated', () {
      expect(
        FlipperNoiseBehavior(),
        isA<FlipperNoiseBehavior>(),
      );
    });

    flameTester.test(
      'plays the flipper sound when moving up',
      (game) async {
        final audioPlayer = _MockPinballAudioPlayer();
        final bloc = _MockFlipperCubit();
        whenListen(
          bloc,
          Stream.fromIterable([FlipperState.movingUp]),
          initialState: FlipperState.movingUp,
        );

        final behavior = FlipperNoiseBehavior();
        await game.pump(
          behavior,
          flipperBloc: bloc,
          audioPlayer: audioPlayer,
        );
        behavior.onNewState(FlipperState.movingUp);
        game.update(0);

        verify(() => audioPlayer.play(PinballAudio.flipper)).called(1);
      },
    );
  });
}
