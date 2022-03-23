import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Spaceship', () {
    late Filter filterData;
    late Fixture fixture;
    late Body body;
    late PinballGame game;
    late Ball ball;
    late SpaceshipDropHole hole;

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

      hole = MockSpaceshipDropHole();
    });

    group('SpaceshipDropHoleBallContactCallback', () {
      test('changes the ball priority on contact', () {
        when(() => hole.outsideLayer).thenReturn(Layer.board);

        SpaceshipDropHoleBallContactCallback().begin(
          hole,
          ball,
          MockContact(),
        );

        verify(() => ball.priority = 1).called(1);
      });

      test('re order the game children', () {
        when(() => hole.outsideLayer).thenReturn(Layer.board);

        SpaceshipDropHoleBallContactCallback().begin(
          hole,
          ball,
          MockContact(),
        );

        verify(game.reorderChildren).called(1);
      });
    });
  });
}
