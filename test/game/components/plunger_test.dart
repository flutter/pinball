// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGame.new);

  group('Plunger', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final plunger = Plunger(Vector2.zero());
        await game.ensureAdd(plunger);

        expect(game.contains(plunger), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final plunger = Plunger(position);
          await game.ensureAdd(plunger);
          game.contains(plunger);

          expect(plunger.body.position, position);
        },
      );

      flameTester.test(
        'is dynamic',
        (game) async {
          final plunger = Plunger(Vector2.zero());
          await game.ensureAdd(plunger);

          expect(plunger.body.bodyType, equals(BodyType.dynamic));
        },
      );

      flameTester.test(
        'ignores gravity',
        (game) async {
          final plunger = Plunger(Vector2.zero());
          await game.ensureAdd(plunger);

          expect(plunger.body.gravityScale, isZero);
        },
      );
    });

    group('first fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final plunger = Plunger(Vector2.zero());
          await game.ensureAdd(plunger);

          expect(plunger.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'shape is a polygon',
        (game) async {
          final plunger = Plunger(Vector2.zero());
          await game.ensureAdd(plunger);

          final fixture = plunger.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.polygon));
        },
      );
    });

    flameTester.test(
      'pull sets a negative linear velocity',
      (game) async {
        final plunger = Plunger(Vector2.zero());
        await game.ensureAdd(plunger);

        plunger.pull();

        expect(plunger.body.linearVelocity.y, isNegative);
      },
    );

    group('release', () {
      flameTester.test(
        'does not set a linear velocity '
        'when plunger is in starting position',
        (game) async {
          final plunger = Plunger(Vector2.zero());
          await game.ensureAdd(plunger);

          plunger.release();

          expect(plunger.body.linearVelocity.y, isZero);
        },
      );

      flameTester.test(
        'sets a positive linear velocity '
        'when plunger is below starting position',
        (game) async {
          final plunger = Plunger(Vector2.zero());
          await game.ensureAdd(plunger);

          plunger.body.setTransform(Vector2(0, -1), 0);
          plunger.release();

          expect(plunger.body.linearVelocity.y, isPositive);
        },
      );
    });
  });

  group('PlungerAnchorPrismaticJointDef', () {
    late Plunger plunger;
    late Plunger anchor;

    setUp(() {
      plunger = Plunger(Vector2.zero());
      anchor = Plunger(Vector2(0, -5));
    });

    group('initializes with', () {
      flameTester.test(
        'plunger as bodyA',
        (game) async {
          await game.ensureAddAll([plunger, anchor]);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );

          expect(jointDef.bodyA, equals(plunger));
        },
      );

      flameTester.test(
        'anchor as bodyB',
        (game) async {
          await game.ensureAddAll([plunger, anchor]);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(jointDef);

          expect(jointDef.bodyB, equals(anchor));
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
  });
}
