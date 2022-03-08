// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGame.new);
  group(
    'Flipper',
    () {
      flameTester.test(
        'loads correctly',
        (game) async {
          final flipper = Flipper(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(flipper);

          expect(game.contains(flipper), isTrue);
        },
      );

      group('constructor', () {
        test('sets BoardSide', () {
          final leftFlipper = Flipper(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          expect(leftFlipper.side, equals(leftFlipper.side));

          final rightFlipper = Flipper(
            position: Vector2.zero(),
            side: BoardSide.right,
          );
          expect(rightFlipper.side, equals(rightFlipper.side));
        });
      });

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            final position = Vector2.all(10);
            final flipper = Flipper(position: position, side: BoardSide.left);
            await game.ensureAdd(flipper);
            game.contains(flipper);

            expect(flipper.body.position, position);
          },
        );

        flameTester.test(
          'is dynamic',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            expect(flipper.body.bodyType, equals(BodyType.dynamic));
          },
        );

        flameTester.test(
          'ignores gravity',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            expect(flipper.body.gravityScale, isZero);
          },
        );

        flameTester.test(
          'has greater mass than Ball',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            final ball = Ball(position: Vector2.zero());

            await game.ensureAdd(flipper);
            await game.ensureAdd(ball);

            expect(
              flipper.body.getMassData().mass,
              greaterThan(ball.body.getMassData().mass),
            );
          },
        );
      });

      group('fixtures', () {
        flameTester.test(
          'has three',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            expect(flipper.body.fixtures.length, equals(3));
          },
        );

        flameTester.test(
          'has density',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            final fixtures = flipper.body.fixtures;
            final density = fixtures.fold<double>(
              0,
              (sum, fixture) => sum + fixture.density,
            );

            expect(density, greaterThan(0));
          },
        );
      });

      group('moveDown', () {
        flameTester.test(
          'sets a negative vertical linear velocity',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            flipper.moveDown();

            expect(flipper.body.linearVelocity.y, isNegative);
            expect(flipper.body.linearVelocity.x, isZero);
          },
        );
      });

      group('moveUp', () {
        flameTester.test(
          'sets a positive vertical linear velocity',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            flipper.moveUp();

            expect(flipper.body.linearVelocity.y, isPositive);
            expect(flipper.body.linearVelocity.x, isZero);
          },
        );
      });
    },
  );

  group(
    'FlipperAnchor',
    () {
      flameTester.test(
        'position is at the left of the flipper '
        'when BoardSide is left',
        (game) async {
          final flipper = Flipper(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          await game.ensureAdd(flipper);

          final flipperAnchor = FlipperAnchor(flipper: flipper);
          await game.ensureAdd(flipperAnchor);

          expect(flipperAnchor.body.position.x, equals(0));
        },
      );

      flameTester.test(
        'position is at the right of the flipper '
        'when BoardSide is right',
        (game) async {
          final flipper = Flipper(
            position: Vector2.zero(),
            side: BoardSide.right,
          );
          await game.ensureAdd(flipper);

          final flipperAnchor = FlipperAnchor(flipper: flipper);
          await game.ensureAdd(flipperAnchor);

          expect(flipperAnchor.body.position.x, equals(Flipper.width));
        },
      );
    },
  );

  group('FlipperAnchorRevoluteJointDef', () {
    group('initializes with', () {
      flameTester.test(
        'limits enabled',
        (game) async {
          final flipper = Flipper(
            position: Vector2.zero(),
            side: BoardSide.left,
          );
          expect(flipper.side, equals(BoardSide.left));
          await game.ensureAdd(flipper);

          final flipperAnchor = FlipperAnchor(flipper: flipper);
          await game.ensureAdd(flipperAnchor);

          final jointDef = FlipperAnchorRevoluteJointDef(
            flipper: flipper,
            anchor: flipperAnchor,
          );

          expect(jointDef.enableLimit, isTrue);
        },
      );

      group('equal upper and lower limits', () {
        flameTester.test(
          'when BoardSide is left',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            expect(flipper.side, equals(BoardSide.left));
            await game.ensureAdd(flipper);

            final flipperAnchor = FlipperAnchor(flipper: flipper);
            await game.ensureAdd(flipperAnchor);

            final jointDef = FlipperAnchorRevoluteJointDef(
              flipper: flipper,
              anchor: flipperAnchor,
            );

            expect(jointDef.lowerAngle, equals(jointDef.upperAngle));
          },
        );

        flameTester.test(
          'when BoardSide is right',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.right,
            );
            expect(flipper.side, equals(BoardSide.right));
            await game.ensureAdd(flipper);

            final flipperAnchor = FlipperAnchor(flipper: flipper);
            await game.ensureAdd(flipperAnchor);

            final jointDef = FlipperAnchorRevoluteJointDef(
              flipper: flipper,
              anchor: flipperAnchor,
            );

            expect(jointDef.lowerAngle, equals(jointDef.upperAngle));
          },
        );
      });
    });

    group(
      'unlocks',
      () {
        flameTester.test(
          'when BoardSide is left',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.left,
            );
            expect(flipper.side, equals(BoardSide.left));
            await game.ensureAdd(flipper);

            final flipperAnchor = FlipperAnchor(flipper: flipper);
            await game.ensureAdd(flipperAnchor);

            final jointDef = FlipperAnchorRevoluteJointDef(
              flipper: flipper,
              anchor: flipperAnchor,
            );
            final joint = game.world.createJoint(jointDef) as RevoluteJoint;

            FlipperAnchorRevoluteJointDef.unlock(joint, flipper.side);

            expect(
              joint.upperLimit,
              isNot(equals(joint.lowerLimit)),
            );
          },
        );

        flameTester.test(
          'when BoardSide is right',
          (game) async {
            final flipper = Flipper(
              position: Vector2.zero(),
              side: BoardSide.right,
            );
            expect(flipper.side, equals(BoardSide.right));
            await game.ensureAdd(flipper);

            final flipperAnchor = FlipperAnchor(flipper: flipper);
            await game.ensureAdd(flipperAnchor);

            final jointDef = FlipperAnchorRevoluteJointDef(
              flipper: flipper,
              anchor: flipperAnchor,
            );
            final joint = game.world.createJoint(jointDef) as RevoluteJoint;

            FlipperAnchorRevoluteJointDef.unlock(joint, flipper.side);

            expect(
              joint.upperLimit,
              isNot(equals(joint.lowerLimit)),
            );
          },
        );
      },
    );
  });
}
