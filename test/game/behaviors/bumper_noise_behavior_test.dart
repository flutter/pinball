// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    _TestBodyComponent child, {
    required PinballAudioPlayer player,
  }) {
    return ensureAdd(
      FlameProvider<PinballAudioPlayer>.value(
        player,
        children: [
          child,
        ],
      ),
    );
  }
}

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() => world.createBody(BodyDef());
}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BumperNoiseBehavior', () {});

  late PinballAudioPlayer player;
  final flameTester = FlameTester(_TestGame.new);

  setUp(() {
    player = _MockPinballAudioPlayer();
  });

  flameTester.testGameWidget(
    'plays bumper sound',
    setUp: (game, _) async {
      final behavior = BumperNoiseBehavior();
      final parent = _TestBodyComponent();
      await game.pump(parent, player: player);
      await parent.ensureAdd(behavior);
      behavior.beginContact(Object(), _MockContact());
    },
    verify: (_, __) async {
      verify(() => player.play(PinballAudio.bumper)).called(1);
    },
  );
}
