// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('Wall', () {
    group('BottomWallBallContactCallback', () {
      test(
        'removes the ball on begin contact when the wall is a bottom one',
        () {
          final wall = MockBottomWall();
          final ballController = MockBallController();
          final ball = MockBall();
          final componentSet = MockComponentSet();

          when(() => componentSet.whereType<BallController>())
              .thenReturn([ballController]);
          when(() => ball.children).thenReturn(componentSet);

          BottomWallBallContactCallback()
            // Remove once https://github.com/flame-engine/flame/pull/1415
            // is merged
            ..end(MockBall(), MockBottomWall(), MockContact())
            ..begin(ball, wall, MockContact());

          verify(ballController.lost).called(1);
        },
      );
    });

    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final wall = Wall(
          start: Vector2.zero(),
          end: Vector2(100, 0),
        );
        await game.ensureAdd(wall);

        expect(game.contains(wall), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);
          game.contains(wall);

          expect(wall.body.position, Vector2.zero());
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);

          expect(wall.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);

          expect(wall.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'has restitution',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);

          final fixture = wall.body.fixtures[0];
          expect(fixture.restitution, greaterThan(0));
        },
      );

      flameTester.test(
        'has no friction',
        (game) async {
          final wall = Wall(
            start: Vector2.zero(),
            end: Vector2(100, 0),
          );
          await game.ensureAdd(wall);

          final fixture = wall.body.fixtures[0];
          expect(fixture.friction, equals(0));
        },
      );
    });
  });
}
