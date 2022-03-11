// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('Plunger', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
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

    group('first fixture', () {
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
    });

    flameTester.test(
      'pull sets a negative linear velocity',
      (game) async {
        final plunger = Plunger(position: Vector2.zero());
        await game.ensureAdd(plunger);

        plunger.pull();

        expect(plunger.body.linearVelocity.y, isNegative);
        expect(plunger.body.linearVelocity.x, isZero);
      },
    );

    group('release', () {
      flameTester.test(
        'does not set a linear velocity '
        'when plunger is in starting position',
        (game) async {
          final plunger = Plunger(position: Vector2.zero());
          await game.ensureAdd(plunger);

          plunger.release();

          expect(plunger.body.linearVelocity.y, isZero);
          expect(plunger.body.linearVelocity.x, isZero);
        },
      );

      flameTester.test(
        'sets a positive linear velocity '
        'when plunger is below starting position',
        (game) async {
          final plunger = Plunger(position: Vector2.zero());
          await game.ensureAdd(plunger);

          plunger.body.setTransform(Vector2(0, -1), 0);
          plunger.release();

          expect(plunger.body.linearVelocity.y, isPositive);
          expect(plunger.body.linearVelocity.x, isZero);
        },
      );
    });
  });

  group('PlungerAnchorPrismaticJointDef', () {
    late Plunger plunger;
    late Anchor anchor;

    final gameBloc = MockGameBloc();

    setUp(() {
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
      plunger = Plunger(position: Vector2.zero());
      anchor = Anchor(position: Vector2(0, -1));
    });

    final flameTester = flameBlocTester(gameBloc: gameBloc);

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

        plunger.pull();
        await tester.pump(const Duration(seconds: 1));

        expect(plunger.body.position.y > anchor.body.position.y, isTrue);
      },
    );

    flameTester.widgetTest(
      'plunger cannot excessively exceed starting position',
      (game, tester) async {
        await game.ensureAddAll([plunger, anchor]);

        final jointDef = PlungerAnchorPrismaticJointDef(
          plunger: plunger,
          anchor: anchor,
        );
        game.world.createJoint(jointDef);

        plunger.pull();
        await tester.pump(const Duration(seconds: 1));

        plunger.release();
        await tester.pump(const Duration(seconds: 1));

        expect(plunger.body.position.y < 1, isTrue);
      },
    );
  });
}
