// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('Plunger', () {
    const compressionDistance = 0.0;

    test('can be instantiated', () {
      expect(Plunger(), isA<Plunger>());
      expect(Plunger.test(), isA<Plunger>());
    });

    flameTester.test(
      'loads correctly',
      (game) async {
        final plunger = Plunger();
        await game.ensureAdd(plunger);
        expect(game.children, contains(plunger));
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.ensureAdd(Plunger());
        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 4.1;
      },
      verify: (game, tester) async {
        final plunger = game.descendants().whereType<Plunger>().first;
        plunger.pull();
        game.update(1);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/plunger/pull.png'),
        );

        plunger.release();
        game.update(1);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/plunger/release.png'),
        );
      },
    );

    group('body', () {
      test('is dynamic', () {
        final body = Plunger().createBody();
        expect(body.bodyType, equals(BodyType.dynamic));
      });

      test('ignores gravity', () {
        final body = Plunger().createBody();
        expect(body.gravityScale, equals(Vector2.zero()));
      });
    });

    group('fixture', () {
      test(
        'exists',
        () async {
          final body = Plunger().createBody();
          expect(body.fixtures[0], isA<Fixture>());
        },
      );

      test(
        'has density',
        () {
          final body = Plunger().createBody();
          final fixture = body.fixtures[0];
          expect(fixture.density, greaterThan(0));
        },
      );
    });

    group('pullFor', () {
      late Plunger plunger;

      setUp(() {
        plunger = Plunger();
      });

      flameTester.testGameWidget(
        'moves downwards for given period when pullFor is called',
        setUp: (game, tester) async {
          await game.ensureAdd(plunger);
        },
        verify: (game, tester) async {
          plunger.pullFor(2);
          game.update(0);

          expect(plunger.body.linearVelocity.y, isPositive);

          // Call game update at 120 FPS, so that the plunger will act as if it
          // was pulled for 2 seconds.
          for (var i = 0.0; i < 2; i += 1 / 120) {
            game.update(1 / 20);
          }

          expect(plunger.body.linearVelocity.y, isZero);
        },
      );
    });

    group('pull', () {
      late Plunger plunger;

      setUp(() {
        plunger = Plunger();
      });

      flameTester.test(
        'moves downwards when pull is called',
        (game) async {
          await game.ensureAdd(plunger);
          plunger.pull();

          expect(plunger.body.linearVelocity.y, isPositive);
          expect(plunger.body.linearVelocity.x, isZero);
        },
      );

      flameTester.test(
          'moves downwards when pull is called '
          'and plunger is below its starting position', (game) async {
        await game.ensureAdd(plunger);
        plunger.pull();
        plunger.release();
        plunger.pull();

        expect(plunger.body.linearVelocity.y, isPositive);
        expect(plunger.body.linearVelocity.x, isZero);
      });
    });

    group('release', () {
      late Plunger plunger;

      setUp(() {
        plunger = Plunger();
      });

      flameTester.test(
          'moves upwards when release is called '
          'and plunger is below its starting position', (game) async {
        await game.ensureAdd(plunger);
        plunger.body.setTransform(Vector2(0, 1), 0);
        plunger.release();

        expect(plunger.body.linearVelocity.y, isNegative);
        expect(plunger.body.linearVelocity.x, isZero);
      });

      flameTester.test(
        'does not move when release is called '
        'and plunger is in its starting position',
        (game) async {
          await game.ensureAdd(plunger);
          plunger.release();

          expect(plunger.body.linearVelocity.y, isZero);
          expect(plunger.body.linearVelocity.x, isZero);
        },
      );
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
          equals(plunger.body.position.y + compressionDistance),
        );
      },
    );
  });

  group('PlungerAnchorPrismaticJointDef', () {
    const compressionDistance = 10.0;
    late Plunger plunger;
    late PlungerAnchor anchor;

    setUp(() {
      plunger = Plunger(
        compressionDistance: compressionDistance,
      );
      anchor = PlungerAnchor(plunger: plunger);
    });

    group('initializes with', () {
      flameTester.test(
        'plunger body as bodyA',
        (game) async {
          await game.ensureAdd(plunger);
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
          await game.ensureAdd(anchor);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(PrismaticJoint(jointDef));

          expect(jointDef.bodyB, equals(anchor.body));
        },
      );

      flameTester.test(
        'limits enabled',
        (game) async {
          await game.ensureAdd(plunger);
          await game.ensureAdd(anchor);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(PrismaticJoint(jointDef));

          expect(jointDef.enableLimit, isTrue);
        },
      );

      flameTester.test(
        'lower translation limit as negative infinity',
        (game) async {
          await game.ensureAdd(plunger);
          await game.ensureAdd(anchor);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(PrismaticJoint(jointDef));

          expect(jointDef.lowerTranslation, equals(double.negativeInfinity));
        },
      );

      flameTester.test(
        'connected body collision enabled',
        (game) async {
          await game.ensureAdd(plunger);
          await game.ensureAdd(anchor);

          final jointDef = PlungerAnchorPrismaticJointDef(
            plunger: plunger,
            anchor: anchor,
          );
          game.world.createJoint(PrismaticJoint(jointDef));

          expect(jointDef.collideConnected, isTrue);
        },
      );
    });

    flameTester.testGameWidget(
      'plunger cannot go below anchor',
      setUp: (game, tester) async {
        await game.ensureAdd(plunger);
        await game.ensureAdd(anchor);

        // Giving anchor a shape for the plunger to collide with.
        anchor.body.createFixtureFromShape(PolygonShape()..setAsBoxXY(2, 1));

        final jointDef = PlungerAnchorPrismaticJointDef(
          plunger: plunger,
          anchor: anchor,
        );
        game.world.createJoint(PrismaticJoint(jointDef));

        await tester.pump(const Duration(seconds: 1));
      },
      verify: (game, tester) async {
        expect(plunger.body.position.y < anchor.body.position.y, isTrue);
      },
    );

    flameTester.testGameWidget(
      'plunger cannot excessively exceed starting position',
      setUp: (game, tester) async {
        await game.ensureAdd(plunger);
        await game.ensureAdd(anchor);

        final jointDef = PlungerAnchorPrismaticJointDef(
          plunger: plunger,
          anchor: anchor,
        );
        game.world.createJoint(PrismaticJoint(jointDef));

        plunger.body.setTransform(Vector2(0, -1), 0);

        await tester.pump(const Duration(seconds: 1));
      },
      verify: (game, tester) async {
        expect(plunger.body.position.y < 1, isTrue);
      },
    );
  });
}
