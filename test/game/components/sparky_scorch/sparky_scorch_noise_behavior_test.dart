// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
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

class _MockBall extends Mock implements Ball {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SparkyScorchNoiseBehavior', () {});

  late PinballPlayer player;
  final flameTester = FlameTester(_TestGame.new);

  setUp(() {
    player = _MockPinballPlayer();
  });

  flameTester.testGameWidget(
    'plays sparky sound',
    setUp: (game, _) async {
      final behavior = SparkyScorchNoiseBehavior();
      final parent = _TestBodyComponent();
      await game.pump(parent, player: player);
      await parent.ensureAdd(behavior);
      behavior.beginContact(_MockBall(), _MockContact());
    },
    verify: (_, __) async {
      verify(() => player.play(PinballAudio.sparky)).called(1);
    },
  );

  flameTester.testGameWidget(
    'plays nothing when it is not a ball',
    setUp: (game, _) async {
      final behavior = SparkyScorchNoiseBehavior();
      final parent = _TestBodyComponent();
      await game.pump(parent, player: player);
      await parent.ensureAdd(behavior);
      behavior.beginContact(Object(), _MockContact());
    },
    verify: (_, __) async {
      verifyNever(() => player.play(PinballAudio.sparky));
    },
  );
}
