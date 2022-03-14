// ignore_for_file: cascade_invocations

import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('FlipperGroup', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final flipperGroup = FlipperGroup(
          position: Vector2.zero(),
          spacing: 0,
        );
        await game.ensureAdd(flipperGroup);

        expect(game.contains(flipperGroup), isTrue);
      },
    );

    group('constructor', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final flipperGroup = FlipperGroup(
            position: position,
            spacing: 0,
          );
          await game.ensureAdd(flipperGroup);

          expect(flipperGroup.position, equals(position));
        },
      );
    });

    group('children', () {
      bool Function(Component) flipperSelector(BoardSide side) =>
          (component) => component is Flipper && component.side == side;

      flameTester.test(
        'has only one left Flipper',
        (game) async {
          final flipperGroup = FlipperGroup(
            position: Vector2.zero(),
            spacing: 0,
          );
          await game.ensureAdd(flipperGroup);

          expect(
            () => flipperGroup.children.singleWhere(
              flipperSelector(BoardSide.left),
            ),
            returnsNormally,
          );
        },
      );

      flameTester.test(
        'has only one right Flipper',
        (game) async {
          final flipperGroup = FlipperGroup(
            position: Vector2.zero(),
            spacing: 0,
          );
          await game.ensureAdd(flipperGroup);

          expect(
            () => flipperGroup.children.singleWhere(
              flipperSelector(BoardSide.right),
            ),
            returnsNormally,
          );
        },
      );

      flameTester.test(
        'spaced correctly',
        (game) async {
          final flipperGroup = FlipperGroup(
            position: Vector2.zero(),
            spacing: 2,
          );
          await game.ready();
          await game.ensureAdd(flipperGroup);

          final leftFlipper = flipperGroup.children.singleWhere(
            flipperSelector(BoardSide.left),
          ) as Flipper;
          final rightFlipper = flipperGroup.children.singleWhere(
            flipperSelector(BoardSide.right),
          ) as Flipper;

          expect(
            leftFlipper.body.position.x + Flipper.width + flipperGroup.spacing,
            equals(rightFlipper.body.position.x),
          );
        },
      );
    });
  });

  group(
    'Flipper',
    () {
      flameTester.test(
        'loads correctly',
        (game) async {
          final leftFlipper = Flipper.left(position: Vector2.zero());
          final rightFlipper = Flipper.right(position: Vector2.zero());
          await game.ready();
          await game.ensureAddAll([leftFlipper, rightFlipper]);

          expect(game.contains(leftFlipper), isTrue);
          expect(game.contains(rightFlipper), isTrue);
        },
      );

      group('constructor', () {
        test('sets BoardSide', () {
          final leftFlipper = Flipper.left(position: Vector2.zero());
          expect(leftFlipper.side, equals(leftFlipper.side));

          final rightFlipper = Flipper.right(position: Vector2.zero());
          expect(rightFlipper.side, equals(rightFlipper.side));
        });
      });

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            final position = Vector2.all(10);
            final flipper = Flipper.left(position: position);
            await game.ensureAdd(flipper);
            game.contains(flipper);

            expect(flipper.body.position, position);
          },
        );

        flameTester.test(
          'is dynamic',
          (game) async {
            final flipper = Flipper.left(position: Vector2.zero());
            await game.ensureAdd(flipper);

            expect(flipper.body.bodyType, equals(BodyType.dynamic));
          },
        );

        flameTester.test(
          'ignores gravity',
          (game) async {
            final flipper = Flipper.left(position: Vector2.zero());
            await game.ensureAdd(flipper);

            expect(flipper.body.gravityScale, isZero);
          },
        );

        flameTester.test(
          'has greater mass than Ball',
          (game) async {
            final flipper = Flipper.left(position: Vector2.zero());
            final ball = Ball(position: Vector2.zero());

            await game.ensureAddAll([flipper, ball]);

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
            final flipper = Flipper.left(position: Vector2.zero());
            await game.ensureAdd(flipper);

            expect(flipper.body.fixtures.length, equals(3));
          },
        );

        flameTester.test(
          'has density',
          (game) async {
            final flipper = Flipper.left(position: Vector2.zero());
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

      group('onKeyEvent', () {
        final leftKeys = UnmodifiableListView([
          LogicalKeyboardKey.arrowLeft,
          LogicalKeyboardKey.keyA,
        ]);
        final rightKeys = UnmodifiableListView([
          LogicalKeyboardKey.arrowRight,
          LogicalKeyboardKey.keyD,
        ]);

        group('and Flipper is left', () {
          late Flipper flipper;

          setUp(() {
            flipper = Flipper.left(position: Vector2.zero());
          });

          testRawKeyDownEvents(leftKeys, (event) {
            flameTester.test(
              'moves upwards '
              'when ${event.logicalKey.keyLabel} is pressed',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isPositive);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyUpEvents(leftKeys, (event) {
            flameTester.test(
              'moves downwards '
              'when ${event.logicalKey.keyLabel} is released',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isNegative);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyUpEvents(rightKeys, (event) {
            flameTester.test(
              'does nothing '
              'when ${event.logicalKey.keyLabel} is released',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isZero);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyDownEvents(rightKeys, (event) {
            flameTester.test(
              'does nothing '
              'when ${event.logicalKey.keyLabel} is pressed',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isZero);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });
        });

        group('and Flipper is right', () {
          late Flipper flipper;

          setUp(() {
            flipper = Flipper.right(position: Vector2.zero());
          });

          testRawKeyDownEvents(rightKeys, (event) {
            flameTester.test(
              'moves upwards '
              'when ${event.logicalKey.keyLabel} is pressed',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isPositive);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyUpEvents(rightKeys, (event) {
            flameTester.test(
              'moves downwards '
              'when ${event.logicalKey.keyLabel} is released',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isNegative);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyUpEvents(leftKeys, (event) {
            flameTester.test(
              'does nothing '
              'when ${event.logicalKey.keyLabel} is released',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isZero);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyDownEvents(leftKeys, (event) {
            flameTester.test(
              'does nothing '
              'when ${event.logicalKey.keyLabel} is pressed',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isZero);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });
        });
      });
    },
  );

  group('FlipperAnchor', () {
    flameTester.test(
      'position is at the left of the left Flipper',
      (game) async {
        final flipper = Flipper.left(position: Vector2.zero());
        await game.ensureAdd(flipper);

        final flipperAnchor = FlipperAnchor(flipper: flipper);
        await game.ensureAdd(flipperAnchor);

        expect(flipperAnchor.body.position.x, equals(-Flipper.width / 2));
      },
    );

    flameTester.test(
      'position is at the right of the right Flipper',
      (game) async {
        final flipper = Flipper.right(position: Vector2.zero());
        await game.ensureAdd(flipper);

        final flipperAnchor = FlipperAnchor(flipper: flipper);
        await game.ensureAdd(flipperAnchor);

        expect(flipperAnchor.body.position.x, equals(Flipper.width / 2));
      },
    );
  });

  group('FlipperAnchorRevoluteJointDef', () {
    group('initializes with', () {
      flameTester.test(
        'limits enabled',
        (game) async {
          final flipper = Flipper.left(position: Vector2.zero());
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
          'when Flipper is left',
          (game) async {
            final flipper = Flipper.left(position: Vector2.zero());
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
          'when Flipper is right',
          (game) async {
            final flipper = Flipper.right(position: Vector2.zero());
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
          'when Flipper is left',
          (game) async {
            final flipper = Flipper.left(position: Vector2.zero());
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
          'when Flipper is right',
          (game) async {
            final flipper = Flipper.right(position: Vector2.zero());
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
