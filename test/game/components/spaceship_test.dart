import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/flame/priority.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Spaceship', () {
    late Filter filterData;
    late Fixture fixture;
    late Body body;
    late PinballGame game;
    late Ball ball;
    late SpaceshipEntrance entrance;
    late SpaceshipHole hole;

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

      entrance = MockSpaceshipEntrance();
      hole = MockSpaceshipHole();
    });

    group('SpaceshipEntranceBallContactCallback', () {
      test('changes the ball priority on contact', () {
        when(() => ball.priority).thenReturn(1);
        when(() => entrance.priority).thenReturn(2);

        SpaceshipEntranceBallContactCallback().begin(
          entrance,
          ball,
          MockContact(),
        );

        verify(() => ball.showInFrontOf(entrance)).called(1);
      });
    });

    group('SpaceshipHoleBallContactCallback', () {
      test('changes the ball priority on contact', () {
        when(() => ball.priority).thenReturn(1);

        SpaceshipHoleBallContactCallback().begin(
          hole,
          ball,
          MockContact(),
        );

        verify(() => ball.sendToBack()).called(1);
      });
    });
  });
}
