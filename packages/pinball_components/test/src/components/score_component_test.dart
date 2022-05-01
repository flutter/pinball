// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.score.points5k.keyName,
    Assets.images.score.points10k.keyName,
    Assets.images.score.points15k.keyName,
    Assets.images.score.points20k.keyName,
    Assets.images.score.points25k.keyName,
    Assets.images.score.points30k.keyName,
    Assets.images.score.points40k.keyName,
    Assets.images.score.points50k.keyName,
    Assets.images.score.points60k.keyName,
    Assets.images.score.points80k.keyName,
    Assets.images.score.points100k.keyName,
    Assets.images.score.points120k.keyName,
    Assets.images.score.points200k.keyName,
    Assets.images.score.points400k.keyName,
    Assets.images.score.points600k.keyName,
    Assets.images.score.points800k.keyName,
    Assets.images.score.points1m.keyName,
    Assets.images.score.points1m2.keyName,
    Assets.images.score.points2m.keyName,
    Assets.images.score.points3m.keyName,
    Assets.images.score.points4m.keyName,
    Assets.images.score.points5m.keyName,
    Assets.images.score.points6m.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('ScoreComponent', () {
    group('renders correctly', () {
      flameTester.testGameWidget(
        '5000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_5k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/5k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '10000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_10k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/10k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '15000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_15k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/15k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '20000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_20k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/20k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '25000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_25k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/25k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '30000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_30k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/30k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '40000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_40k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/40k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '50000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_50k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/50k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '60000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_60k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/60k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '80000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_80k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/80k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '100000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_100k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/100k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '120000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_120k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/120k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '200000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_200k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/200k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '400000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_400k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/400k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '600000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_600k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/600k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '800000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_800k,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/800k.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '1000000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_1m,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/1m.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '1200000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_1m2,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/1m2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '2000000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_2m,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/2m.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '3000000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_3m,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/3m.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '4000000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_4m,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/4m.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '5000000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_5m,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/5m.png'),
          );
        },
      );

      flameTester.testGameWidget(
        '6000000 points',
        setUp: (game, tester) async {
          await game.images.loadAll(assets);
          await game.ensureAdd(
            ScoreComponent(
              points: Points.points_6m,
              position: Vector2.zero(),
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
            matchesGoldenFile('golden/score/6m.png'),
          );
        },
      );
    });
  });

  group('PointsX', () {
    test('5k value return 5000', () {
      expect(Points.points_5k.value, 5000);
    });

    test('10k value return 10000', () {
      expect(Points.points_10k.value, 10000);
    });

    test('15k value return 15000', () {
      expect(Points.points_15k.value, 15000);
    });

    test('20k value return 20000', () {
      expect(Points.points_20k.value, 20000);
    });

    test('25k value return 25000', () {
      expect(Points.points_25k.value, 25000);
    });

    test('30k value return 30000', () {
      expect(Points.points_30k.value, 30000);
    });

    test('40k value return 40000', () {
      expect(Points.points_40k.value, 40000);
    });

    test('50k value return 50000', () {
      expect(Points.points_50k.value, 50000);
    });

    test('60k value return 60000', () {
      expect(Points.points_60k.value, 60000);
    });

    test('80k value return 80000', () {
      expect(Points.points_80k.value, 80000);
    });

    test('100k value return 100000', () {
      expect(Points.points_100k.value, 100000);
    });

    test('120k value return 120000', () {
      expect(Points.points_120k.value, 120000);
    });

    test('200k value return 200000', () {
      expect(Points.points_200k.value, 200000);
    });

    test('400k value return 400000', () {
      expect(Points.points_400k.value, 400000);
    });

    test('600k value return 600000', () {
      expect(Points.points_600k.value, 600000);
    });

    test('1m value return 1000000', () {
      expect(Points.points_1m.value, 1000000);
    });

    test('1m2 value return 1200000', () {
      expect(Points.points_1m2.value, 1200000);
    });

    test('2m value return 2000000', () {
      expect(Points.points_2m.value, 2000000);
    });

    test('3m value return 3000000', () {
      expect(Points.points_3m.value, 3000000);
    });

    test('4m value return 4000000', () {
      expect(Points.points_4m.value, 4000000);
    });

    test('5m value return 5000000', () {
      expect(Points.points_5m.value, 5000000);
    });

    test('6m value return 6000000', () {
      expect(Points.points_6m.value, 6000000);
    });
  });

  group('Effects', () {
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreComponent(
            points: Points.points_6m,
            position: Vector2.zero(),
          ),
        );
      },
      verify: (game, tester) async {
        final texts = game.descendants().whereType<SpriteComponent>().length;
        expect(texts, equals(1));
      },
    );

    flameTester.testGameWidget(
      'has a movement effect',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreComponent(
            points: Points.points_6m,
            position: Vector2.zero(),
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
        await game.images.loadAll(assets);
        game.camera.followVector2(Vector2.zero());
        await game.ensureAdd(
          ScoreComponent(
            points: Points.points_6m,
            position: Vector2.zero(),
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
  });
}
