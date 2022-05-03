// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class _MockControlledBall extends Mock implements ControlledBall {}

class _MockBallController extends Mock implements BallController {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('Drain', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final drain = Drain();
        await game.ensureAdd(drain);
        expect(game.contains(drain), isTrue);
      },
    );

    flameTester.test(
      'body is static',
      (game) async {
        final drain = Drain();
        await game.ensureAdd(drain);
        expect(drain.body.bodyType, equals(BodyType.static));
      },
    );

    flameTester.test(
      'is sensor',
      (game) async {
        final drain = Drain();
        await game.ensureAdd(drain);
        expect(drain.body.fixtures.first.isSensor, isTrue);
      },
    );

    test(
      'calls lost on contact with ball',
      () async {
        final drain = Drain();
        final ball = _MockControlledBall();
        final controller = _MockBallController();
        when(() => ball.controller).thenReturn(controller);

        drain.beginContact(ball, _MockContact());

        verify(controller.lost).called(1);
      },
    );
  });
}
