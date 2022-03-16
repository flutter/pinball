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
  final flameTester = FlameTester(Forge2DGame.new);

  group('Plunger', () {
    const compressionDistance = 0.0;

    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final plunger = Plunger(
          compressionDistance: compressionDistance,
        );
        await game.ensureAdd(plunger);

        expect(game.contains(plunger), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'is dynamic',
        (game) async {
          final plunger = Plunger(
            compressionDistance: compressionDistance,
          );
          await game.ensureAdd(plunger);

          expect(plunger.body.bodyType, equals(BodyType.dynamic));
        },
      );

      flameTester.test(
        'ignores gravity',
        (game) async {
          final plunger = Plunger(
            compressionDistance: compressionDistance,
          );
          await game.ensureAdd(plunger);

          expect(plunger.body.gravityScale, isZero);
        },
      );
    });

    group('fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final plunger = Plunger(
            compressionDistance: compressionDistance,
          );
          await game.ensureAdd(plunger);

          expect(plunger.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'shape is a polygon',
        (game) async {
          final plunger = Plunger(
            compressionDistance: compressionDistance,
          );
          await game.ensureAdd(plunger);

          final fixture = plunger.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.polygon));
        },
      );

      flameTester.test(
        'has density',
        (game) async {
          final plunger = Plunger(
            compressionDistance: compressionDistance,
          );
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
        plunger = Plunger(
          compressionDistance: compressionDistance,
        );
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
    const compressionDistance = 10.0;

    flameTester.test(
      'position is a compression distance below the Plunger',
      (game) async {
        final plunger = Plunger(
          compressionDistance: compressionDistance,
        );
        await game.ensureAdd(plunger);

        final plungerAnchor = PlungerAnchor(plunger: plunger);
        await game.ensureAdd(plungerAnchor);

        expect(
          plungerAnchor.body.position.y,
          equals(plunger.body.position.y - compressionDistance),
        );
      },
    );
  });

  group('PlungerAnchorPrismaticJointDef', () {
    const compressionDistance = 10.0;
    final gameBloc = MockGameBloc();
    late Plunger plunger;

    setUp(() {
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
      plunger = Plunger(
        compressionDistance: compressionDistance,
      );
    });

    final flameTester = flameBlocTester(gameBloc: () => gameBloc);

    group('initializes with', () {
      flameTester.test(
        'plunger body as bodyA',
        (game) async {
          await game.ensureAdd(plunger);
          final anchor = PlungerAnchor(plunger: plunger);
          await game.ensureAdd(anchor);

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
          await game.ensureAdd(plunger);
          final anchor = PlungerAnchor(plunger: plunger);
          await game.ensureAdd(anchor);

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
          await game.ensureAdd(plunger);
          final anchor = PlungerAnchor(plunger: plunger);
          await game.ensureAdd(anchor);

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
          await game.ensureAdd(plunger);
          final anchor = PlungerAnchor(plunger: plunger);
          await game.ensureAdd(anchor);

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
          await game.ensureAdd(plunger);
          final anchor = PlungerAnchor(plunger: plunger);
          await game.ensureAdd(anchor);

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
          await game.ensureAdd(plunger);
          final anchor = PlungerAnchor(plunger: plunger);
          await game.ensureAdd(anchor);

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
          await game.ensureAdd(plunger);
          final anchor = PlungerAnchor(plunger: plunger);
          await game.ensureAdd(anchor);

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
