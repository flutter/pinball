// ignore_for_file: cascade_invocations

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
  }) {
    return ensureAdd(
      FlameProvider<PinballAudioPlayer>.value(
        pinballAudioPlayer ?? _MockPinballAudioPlayer(),
        children: [
          FlameBlocProvider<PlungerCubit, PlungerState>.value(
            value: PlungerCubit(),
            children: [child],
          ),
        ],
      ),
    );
  }
}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

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

    flameTester.test('can be loaded', (game) async {
      final parent = Component();
      final behavior = PlungerNoiseBehavior();
      await game.pump(parent);
      await parent.ensureAdd(behavior);
      expect(parent.children, contains(behavior));
    });

    flameTester.test('plays the correct sound on when released', (game) async {
      final parent = Component();
      final behavior = PlungerNoiseBehavior();
      await game.pump(
        parent,
        pinballAudioPlayer: audioPlayer,
      );
      await parent.ensureAdd(behavior);

      behavior.onNewState(PlungerState.releasing);

      verify(() => audioPlayer.play(PinballAudio.launcher)).called(1);
    });
  });
}
