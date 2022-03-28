// ignore_for_file: cascade_invocations

import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Spaceship', () {
    late Filter filterData;
    late Fixture fixture;
    late Body body;
    late Ball ball;
    late SpaceshipEntrance entrance;
    late SpaceshipHole hole;
    late Forge2DGame game;

    setUp(() {
      filterData = MockFilter();

      fixture = MockFixture();
      when(() => fixture.filterData).thenReturn(filterData);

      body = MockBody();
      when(() => body.fixtures).thenReturn([fixture]);

      game = MockGame();

      ball = MockBall();
      when(() => ball.gameRef).thenReturn(game);
      when(() => ball.body).thenReturn(body);

      entrance = MockSpaceshipEntrance();
      hole = MockSpaceshipHole();
    });

    group('Spaceship', () {
      testWidgets('renders correctly', (tester) async {
        final game = TestGame();

        await tester.runAsync(() async {
          await tester.pumpWidget(GameWidget(game: game));
          await game.ready();
          await game.addFromBlueprint(Spaceship(position: Vector2(30, -30)));
          await game.ready();
          await tester.pump();
        });

        await expectLater(
          find.byGame<Forge2DGame>(),
          matchesGoldenFile('golden/spaceship.png'),
        );
      });
    });

    group('SpaceshipEntranceBallContactCallback', () {
      test('changes the ball priority on contact', () {
        SpaceshipEntranceBallContactCallback().begin(
          entrance,
          ball,
          MockContact(),
        );

        verify(() => ball.priority = 3).called(1);
      });

      test('re order the game children', () {
        SpaceshipEntranceBallContactCallback().begin(
          entrance,
          ball,
          MockContact(),
        );

        verify(game.reorderChildren).called(1);
      });
    });

    group('SpaceshipHoleBallContactCallback', () {
      test('changes the ball priority on contact', () {
        SpaceshipHoleBallContactCallback().begin(
          hole,
          ball,
          MockContact(),
        );

        verify(() => ball.priority = 1).called(1);
      });

      test('re order the game children', () {
        SpaceshipHoleBallContactCallback().begin(
          hole,
          ball,
          MockContact(),
        );

        verify(game.reorderChildren).called(1);
      });
    });
  });
}
