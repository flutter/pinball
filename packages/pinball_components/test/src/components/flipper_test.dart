// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.flipper.left.keyName,
    Assets.images.flipper.right.keyName,
    theme.Assets.images.dash.ball.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('Flipper', () {
    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final leftFlipper = Flipper(
          side: BoardSide.left,
        )..initialPosition = Vector2(-10, 0);
        final rightFlipper = Flipper(
          side: BoardSide.right,
        )..initialPosition = Vector2(10, 0);

        await game.ensureAddAll([leftFlipper, rightFlipper]);
        game.camera.followVector2(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/flipper.png'),
        );
      },
    );

    flameTester.test(
      'loads correctly',
      (game) async {
        final leftFlipper = Flipper(side: BoardSide.left);
        final rightFlipper = Flipper(side: BoardSide.right);
        await game.ready();
        await game.ensureAddAll([leftFlipper, rightFlipper]);

        expect(game.contains(leftFlipper), isTrue);
        expect(game.contains(rightFlipper), isTrue);
      },
    );

    group('constructor', () {
      test('sets BoardSide', () {
        final leftFlipper = Flipper(side: BoardSide.left);
        expect(leftFlipper.side, equals(leftFlipper.side));

        final rightFlipper = Flipper(side: BoardSide.right);
        expect(rightFlipper.side, equals(rightFlipper.side));
      });
    });

    group('body', () {
      flameTester.test(
        'is dynamic',
        (game) async {
          final flipper = Flipper(side: BoardSide.left);
          await game.ensureAdd(flipper);
          expect(flipper.body.bodyType, equals(BodyType.dynamic));
        },
      );

      flameTester.test(
        'ignores gravity',
        (game) async {
          final flipper = Flipper(side: BoardSide.left);
          await game.ensureAdd(flipper);

          expect(flipper.body.gravityScale, equals(Vector2.zero()));
        },
      );

      flameTester.test(
        'has greater mass than Ball',
        (game) async {
          final flipper = Flipper(side: BoardSide.left);
          final ball = Ball();

          await game.ready();
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
          final flipper = Flipper(side: BoardSide.left);
          await game.ensureAdd(flipper);

          expect(flipper.body.fixtures.length, equals(3));
        },
      );

      flameTester.test(
        'has density',
        (game) async {
          final flipper = Flipper(side: BoardSide.left);
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

    flameTester.test(
      'moveDown applies downward velocity',
      (game) async {
        final flipper = Flipper(side: BoardSide.left);
        await game.ensureAdd(flipper);

        expect(flipper.body.linearVelocity, equals(Vector2.zero()));
        flipper.moveDown();

        expect(flipper.body.linearVelocity.y, isPositive);
      },
    );

    flameTester.test(
      'moveUp applies upward velocity',
      (game) async {
        final flipper = Flipper(side: BoardSide.left);
        await game.ensureAdd(flipper);

        expect(flipper.body.linearVelocity, equals(Vector2.zero()));
        flipper.moveUp();

        expect(flipper.body.linearVelocity.y, isNegative);
      },
    );
  });
}
