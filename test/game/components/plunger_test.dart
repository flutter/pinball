// ignore_for_file: cascade_invocations

import 'dart:collection';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGame.new);

  group('Plunger', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final plunger = Plunger(position: Vector2.zero());
        await game.ensureAdd(plunger);

        expect(game.contains(plunger), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final plunger = Plunger(position: position);
          await game.ensureAdd(plunger);
          game.contains(plunger);

          expect(plunger.body.position, position);
        },
      );

      flameTester.test(
        'is dynamic',
        (game) async {
          final plunger = Plunger(position: Vector2.zero());
          await game.ensureAdd(plunger);

          expect(plunger.body.bodyType, equals(BodyType.dynamic));
        },
      );

      flameTester.test(
        'ignores gravity',
        (game) async {
          final plunger = Plunger(position: Vector2.zero());
          await game.ensureAdd(plunger);

          expect(plunger.body.gravityScale, isZero);
        },
      );
    });

    group('fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final plunger = Plunger(position: Vector2.zero());
          await game.ensureAdd(plunger);

          expect(plunger.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'shape is a polygon',
        (game) async {
          final plunger = Plunger(position: Vector2.zero());
          await game.ensureAdd(plunger);

          final fixture = plunger.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.polygon));
        },
      );

      flameTester.test(
        'has density',
        (game) async {
          final plunger = Plunger(position: Vector2.zero());
          await game.ensureAdd(plunger);

          final fixture = plunger.body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );
    });

    group('onKeyEvent', () {
      final keys = UnmodifiableListView([
        LogicalKeyboardKey.space,
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.keyS,
      ]);

      late Plunger plunger;

      setUp(() {
        plunger = Plunger(position: Vector2.zero());
      });

      testRawKeyUpEvents(keys, (event) {
        final keyLabel = (event.logicalKey != LogicalKeyboardKey.space)
            ? event.logicalKey.keyLabel
            : 'Space';
        flameTester.test(
          'moves upwards when $keyLabel is released '
          'and plunger is below its starting position',
          (game) async {
            await game.ensureAdd(plunger);
            plunger.body.setTransform(Vector2(0, -1), 0);
            plunger.onKeyEvent(event, {});

            expect(plunger.body.linearVelocity.y, isPositive);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });

      testRawKeyUpEvents(keys, (event) {
        final keyLabel = (event.logicalKey != LogicalKeyboardKey.space)
            ? event.logicalKey.keyLabel
            : 'Space';
        flameTester.test(
          'does not move when $keyLabel is released '
          'and plunger is in its starting position',
          (game) async {
            await game.ensureAdd(plunger);
            plunger.onKeyEvent(event, {});

            expect(plunger.body.linearVelocity.y, isZero);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });

      testRawKeyDownEvents(keys, (event) {
        final keyLabel = (event.logicalKey != LogicalKeyboardKey.space)
            ? event.logicalKey.keyLabel
            : 'Space';
        flameTester.test(
          'moves downwards when $keyLabel is pressed',
          (game) async {
            await game.ensureAdd(plunger);
            plunger.onKeyEvent(event, {});

            expect(plunger.body.linearVelocity.y, isNegative);
            expect(plunger.body.linearVelocity.x, isZero);
          },
        );
      });
    });
  });

  group('PlungerAnchor', () {
    flameTester.test(
      'position is a compression distance below the Plunger',
      (game) async {
        final plunger = Plunger(position: Vector2.zero());
        await game.ensureAdd(plunger);

        final plungerAnchor = PlungerAnchor(plunger: plunger);
        await game.ensureAdd(plungerAnchor);

        expect(
          plungerAnchor.body.position.y,
          equals(plunger.body.position.y - Plunger.compressionDistance),
        );
      },
    );
  });

  group('PlungerAnchorPrismaticJointDef', () {
    late GameBloc gameBloc;
    late Plunger plunger;
    late Anchor anchor;

    setUp(() {
      gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
      plunger = Plunger(position: Vector2.zero());
      anchor = Anchor(position: Vector2(0, -1));
    });

    final flameTester = flameBlocTester(
      gameBlocBuilder: () {
        return gameBloc;
      },
    );

    flameTester.test(
      'throws AssertionError '
      'when anchor is above plunger',
      (game) async {
        final anchor = Anchor(position: Vector2(0, 1));
        await game.ensureAddAll([plunger, anchor]);

        expect(
          () => PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          ),
          throwsAssertionError,
        );
      },
    );

    flameTester.test(
      'throws AssertionError '
      'when anchor is in same position as plunger',
      (game) async {
        final anchor = Anchor(position: Vector2.zero());
        await game.ensureAddAll([plunger, anchor]);

        expect(
          () => PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          ),
          throwsAssertionError,
        );
      },
    );

    group('initializes with', () {
      flameTester.test(
        'plunger body as bodyA',
        (game) async {
          await game.ensureAddAll([plunger, anchor]);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );

          expect(jointDef.bodyA, equals(plunger.body));
        },
      );

      flameTester.test(
        'anchor body as bodyB',
        (game) async {
          await game.ensureAddAll([plunger, anchor]);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(jointDef);

          expect(jointDef.bodyB, equals(anchor.body));
        },
      );

      flameTester.test(
        'limits enabled',
        (game) async {
          await game.ensureAddAll([plunger, anchor]);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(jointDef);

          expect(jointDef.enableLimit, isTrue);
        },
      );

      flameTester.test(
        'lower translation limit as negative infinity',
        (game) async {
          await game.ensureAddAll([plunger, anchor]);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(jointDef);

          expect(jointDef.lowerTranslation, equals(double.negativeInfinity));
        },
      );

      flameTester.test(
        'connected body collison enabled',
        (game) async {
          await game.ensureAddAll([plunger, anchor]);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(jointDef);

          expect(jointDef.collideConnected, isTrue);
        },
      );
    });

    testRawKeyUpEvents([LogicalKeyboardKey.space], (event) {
      flameTester.widgetTest(
        'plunger cannot go below anchor',
        (game, tester) async {
          await game.ensureAddAll([plunger, anchor]);

          // Giving anchor a shape for the plunger to collide with.
          anchor.body.createFixtureFromShape(PolygonShape()..setAsBoxXY(2, 1));

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(jointDef);

          await tester.pump(const Duration(seconds: 1));

          expect(plunger.body.position.y > anchor.body.position.y, isTrue);
        },
      );
    });

    testRawKeyUpEvents([LogicalKeyboardKey.space], (event) {
      flameTester.widgetTest(
        'plunger cannot excessively exceed starting position',
        (game, tester) async {
          await game.ensureAddAll([plunger, anchor]);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(jointDef);

          plunger.body.setTransform(Vector2(0, -1), 0);

          await tester.pump(const Duration(seconds: 1));

          expect(plunger.body.position.y < 1, isTrue);
        },
      );
    });
  });
}
