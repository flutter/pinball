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
        'one million points',
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
