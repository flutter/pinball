// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(_TestBodyComponent child, {required PinballPlayer player}) {
    return ensureAdd(
      FlameProvider<PinballPlayer>.value(
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

class _MockPinballPlayer extends Mock implements PinballPlayer {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BumperNoiseBehavior', () {});

  late PinballPlayer player;
  final flameTester = FlameTester(_TestGame.new);

  setUp(() {
    player = _MockPinballPlayer();
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
