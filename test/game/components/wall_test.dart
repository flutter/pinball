// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballTestGame.new);

  group('Wall', () {
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

  group(
    'BottomWall',
    () {
      group('removes ball on contact', () {
        late GameBloc gameBloc;

        setUp(() {
          gameBloc = GameBloc();
        });

        final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
          gameBuilder: EmptyPinballTestGame.new,
          blocBuilder: () => gameBloc,
        );

        flameBlocTester.testGameWidget(
          'when ball is launch',
          setUp: (game, tester) async {
            final ball = ControlledBall.launch(theme: game.theme);
            final wall = BottomWall();
            await game.ensureAddAll([ball, wall]);
            game.addContactCallback(BottomWallBallContactCallback());

            beginContact(game, ball, wall);
            await game.ready();

            expect(game.contains(ball), isFalse);
          },
        );

        flameBlocTester.testGameWidget(
          'when ball is bonus',
          setUp: (game, tester) async {
            final ball = ControlledBall.bonus(theme: game.theme);
            final wall = BottomWall();
            await game.ensureAddAll([ball, wall]);
            game.addContactCallback(BottomWallBallContactCallback());

            beginContact(game, ball, wall);
            await game.ready();

            expect(game.contains(ball), isFalse);
          },
        );

        flameTester.test(
          'when ball is debug',
          (game) async {
            final ball = ControlledBall.debug();
            final wall = BottomWall();
            await game.ensureAddAll([ball, wall]);
            game.addContactCallback(BottomWallBallContactCallback());

            beginContact(game, ball, wall);
            await game.ready();

            expect(game.contains(ball), isFalse);
          },
        );
      });
    },
  );
}
