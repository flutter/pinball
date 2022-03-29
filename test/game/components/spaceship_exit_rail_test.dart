import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SpaceshipExitRail', () {
    late Filter filterData;
    late Fixture fixture;
    late Body body;
    late PinballGame game;
    late Ball ball;
    late SpaceshipExitRailEnd exitRailEnd;

    setUp(() {
      filterData = MockFilter();

      fixture = MockFixture();
      when(() => fixture.filterData).thenReturn(filterData);

      body = MockBody();
      when(() => body.fixtures).thenReturn([fixture]);

      game = MockPinballGame();

      ball = MockBall();
      when(() => ball.gameRef).thenReturn(game);
      when(() => ball.body).thenReturn(body);

      exitRailEnd = MockSpaceshipExitRailEnd();
    });

    group('SpaceshipExitHoleBallContactCallback', () {
      test('changes the ball priority on contact', () {
        when(() => exitRailEnd.outsideLayer).thenReturn(Layer.board);

        SpaceshipExitRailEndBallContactCallback().begin(
          exitRailEnd,
          ball,
          MockContact(),
        );

        verify(() => ball.priority = 1).called(1);
      });

      test('reorders the game children', () {
        when(() => exitRailEnd.outsideLayer).thenReturn(Layer.board);

        SpaceshipExitRailEndBallContactCallback().begin(
          exitRailEnd,
          ball,
          MockContact(),
        );

        verify(game.reorderChildren).called(1);
      });
    });
  });
}
