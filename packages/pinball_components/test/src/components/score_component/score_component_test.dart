// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/score_component/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(
    () => TestGame([
      Assets.images.score.fiveThousand.keyName,
      Assets.images.score.twentyThousand.keyName,
      Assets.images.score.twoHundredThousand.keyName,
      Assets.images.score.oneMillion.keyName,
    ]),
  );

  group('ScoreComponent', () {
    test('can be instantiated', () {
      expect(
        ScoreComponent(
          points: Points.fiveThousand,
          position: Vector2.zero(),
          effectController: EffectController(duration: 1),
        ),
        isA<ScoreComponent>(),
      );
    });

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, tester) async {
        await game.onLoad();
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreComponent(
            points: Points.oneMillion,
            position: Vector2.zero(),
            effectController: EffectController(duration: 1),
          ),
        );
      },
      verify: (game, tester) async {
        final texts = game.descendants().whereType<SpriteComponent>().length;
        expect(texts, equals(1));
      },
    );

    flameTester.test(
      'adds a ScoreComponentScalingBehavior',
      (game) async {
        await game.onLoad();
        game.camera.followVector2(Vector2.zero());
        final component = ScoreComponent(
          points: Points.oneMillion,
          position: Vector2.zero(),
          effectController: EffectController(duration: 1),
        );
        await game.ensureAdd(component);

        expect(
          component.children.whereType<ScoreComponentScalingBehavior>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'has a movement effect',
      setUp: (game, tester) async {
        await game.onLoad();
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreComponent.test(
            points: Points.oneMillion,
            position: Vector2.zero(),
            effectController: EffectController(duration: 1),
          ),
        );

        game.update(0.5);
        await tester.pump();
      },
      verify: (game, tester) async {
        final text = game.descendants().whereType<SpriteComponent>().first;
        expect(text.firstChild<MoveEffect>(), isNotNull);
      },
    );

    flameTester.testGameWidget(
      'is removed once finished',
      setUp: (game, tester) async {
        await game.onLoad();
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreComponent.test(
            points: Points.oneMillion,
            position: Vector2.zero(),
            effectController: EffectController(duration: 1),
          ),
        );

        game.update(1);
        game.update(0); // Ensure all component removals
        await tester.pump();
      },
      verify: (game, tester) async {
        expect(game.children.length, equals(0));
      },
    );

    group('renders correctly', () {
      const goldensPath = '../golden/score/';

      flameTester.testGameWidget(
        '5000 points',
        setUp: (game, tester) async {
          await game.onLoad();
          await game.ensureAdd(
            ScoreComponent.test(
              points: Points.fiveThousand,
              position: Vector2.zero(),
              effectController: EffectController(duration: 1),
            ),
          );

          game.camera
            ..followVector2(Vector2.zero())
            ..zoom = 8;

          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldensPath}5k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '20000 points',
        setUp: (game, tester) async {
          await game.onLoad();
          await game.ensureAdd(
            ScoreComponent.test(
              points: Points.twentyThousand,
              position: Vector2.zero(),
              effectController: EffectController(duration: 1),
            ),
          );

          game.camera
            ..followVector2(Vector2.zero())
            ..zoom = 8;

          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldensPath}20k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '200000 points',
        setUp: (game, tester) async {
          await game.onLoad();
          await game.ensureAdd(
            ScoreComponent.test(
              points: Points.twoHundredThousand,
              position: Vector2.zero(),
              effectController: EffectController(duration: 1),
            ),
          );

          game.camera
            ..followVector2(Vector2.zero())
            ..zoom = 8;

          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldensPath}200k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '1000000 points',
        setUp: (game, tester) async {
          await game.onLoad();
          await game.ensureAdd(
            ScoreComponent.test(
              points: Points.oneMillion,
              position: Vector2.zero(),
              effectController: EffectController(duration: 1),
            ),
          );

          game.camera
            ..followVector2(Vector2.zero())
            ..zoom = 8;

          await tester.pump();
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<TestGame>(),
            matchesGoldenFile('${goldensPath}1m.png'),
          );
        },
      );
    });
  });

  group('PointsX', () {
    test('5k value return 5000', () {
      expect(Points.fiveThousand.value, 5000);
    });

    test('20k value return 20000', () {
      expect(Points.twentyThousand.value, 20000);
    });

    test('200k value return 200000', () {
      expect(Points.twoHundredThousand.value, 200000);
    });

    test('1m value return 1000000', () {
      expect(Points.oneMillion.value, 1000000);
    });
  });
}
