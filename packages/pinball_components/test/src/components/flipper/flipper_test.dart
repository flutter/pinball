// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

import '../../../helpers/helpers.dart';

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

        await game.world.ensureAddAll([leftFlipper, rightFlipper]);
        game.camera.moveTo(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('../golden/flipper.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final leftFlipper = Flipper(side: BoardSide.left);
        final rightFlipper = Flipper(side: BoardSide.right);
        await game.ready();
        await game.ensureAddAll([leftFlipper, rightFlipper]);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Flipper>().length, equals(2));
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
      flameTester.testGameWidget(
        'is dynamic',
        setUp: (game, _) async {
          final flipper = Flipper(side: BoardSide.left);
          await game.ensureAdd(flipper);
        },
        verify: (game, _) async {
          final flipper = game.descendants().whereType<Flipper>().single;
          expect(flipper.body.bodyType, equals(BodyType.dynamic));
        },
      );

      flameTester.testGameWidget(
        'ignores gravity',
        setUp: (game, _) async {
          final flipper = Flipper(side: BoardSide.left);
          await game.ensureAdd(flipper);
        },
        verify: (game, _) async {
          final flipper = game.descendants().whereType<Flipper>().single;

          expect(flipper.body.gravityScale, equals(Vector2.zero()));
        },
      );

      flameTester.testGameWidget(
        'has greater mass than Ball',
        setUp: (game, _) async {
          final flipper = Flipper(side: BoardSide.left);
          final ball = Ball();
          await game.ready();
          await game.ensureAddAll([flipper, ball]);
        },
        verify: (game, _) async {
          final flipper = game.descendants().whereType<Flipper>().single;
          final ball = game.descendants().whereType<Ball>().single;

          expect(
            flipper.body.getMassData().mass,
            greaterThan(ball.body.getMassData().mass),
          );
        },
      );
    });

    group('fixtures', () {
      flameTester.testGameWidget(
        'has three',
        setUp: (game, _) async {
          final flipper = Flipper(side: BoardSide.left);
          await game.ensureAdd(flipper);
        },
        verify: (game, _) async {
          final flipper = game.descendants().whereType<Flipper>().single;
          expect(flipper.body.fixtures.length, equals(3));
        },
      );

      flameTester.testGameWidget(
        'has density',
        setUp: (game, _) async {
          final flipper = Flipper(side: BoardSide.left);
          await game.ensureAdd(flipper);
        },
        verify: (game, _) async {
          final flipper = game.descendants().whereType<Flipper>().single;

          final fixtures = flipper.body.fixtures;
          final density = fixtures.fold<double>(
            0,
            (sum, fixture) => sum + fixture.density,
          );

          expect(density, greaterThan(0));
        },
      );
    });
  });
}
