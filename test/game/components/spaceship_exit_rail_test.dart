import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SpaceshipExitRail', () {
    late PinballGame game;
    late SpaceshipExitRailEnd exitRailEnd;
    late Ball ball;
    late Body body;
    late Fixture fixture;
    late Filter filterData;

    setUp(() {
      game = MockPinballGame();

      exitRailEnd = MockSpaceshipExitRailEnd();

      ball = MockBall();
      body = MockBody();
      when(() => ball.gameRef).thenReturn(game);
      when(() => ball.body).thenReturn(body);

      fixture = MockFixture();
      filterData = MockFilter();
      when(() => body.fixtures).thenReturn([fixture]);
      when(() => fixture.filterData).thenReturn(filterData);
    });

    // TODO(alestiago): Make ContactCallback private and use `beginContact`
    // instead.
    group('SpaceshipExitHoleBallContactCallback', () {
      setUp(() {
        when(() => ball.priority).thenReturn(1);
        when(() => exitRailEnd.outsideLayer).thenReturn(Layer.board);
        when(() => exitRailEnd.outsidePriority).thenReturn(0);
      });

      test('changes the ball priority on contact', () {
        SpaceshipExitRailEndBallContactCallback().begin(
          exitRailEnd,
          ball,
          MockContact(),
        );

        verify(() => ball.sendTo(exitRailEnd.outsidePriority)).called(1);
      });

      test('changes the ball layer on contact', () {
        SpaceshipExitRailEndBallContactCallback().begin(
          exitRailEnd,
          ball,
          MockContact(),
        );

        verify(() => ball.layer = exitRailEnd.outsideLayer).called(1);
      });
    });
  });
}
