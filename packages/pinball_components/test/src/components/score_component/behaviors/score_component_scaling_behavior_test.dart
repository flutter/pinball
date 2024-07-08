// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/score_component/behaviors/behaviors.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('ScoreComponentScalingBehavior', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    final flameTester = FlameTester(
      () => TestGame([
        Assets.images.score.fiveThousand.keyName,
        Assets.images.score.twentyThousand.keyName,
        Assets.images.score.twoHundredThousand.keyName,
        Assets.images.score.oneMillion.keyName,
      ]),
    );

    test('can be instantiated', () {
      expect(
        ScoreComponentScalingBehavior(),
        isA<ScoreComponentScalingBehavior>(),
      );
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        await game.onLoad();
        final parent = ScoreComponent.test(
          points: Points.fiveThousand,
          position: Vector2.zero(),
          effectController: EffectController(duration: 1),
        );
        final behavior = ScoreComponentScalingBehavior();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final scoreComponent =
            game.descendants().whereType<ScoreComponent>().single;
        expect(
          scoreComponent.children
              .whereType<ScoreComponentScalingBehavior>()
              .length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'scales the sprite',
      setUp: (game, _) async {
        await game.onLoad();
        final parent1 = ScoreComponent.test(
          points: Points.fiveThousand,
          position: Vector2(0, 10),
          effectController: EffectController(duration: 1),
        );
        final parent2 = ScoreComponent.test(
          points: Points.fiveThousand,
          position: Vector2(0, -10),
          effectController: EffectController(duration: 1),
        );
        await game.ensureAddAll([parent1, parent2]);

        await parent1.ensureAdd(ScoreComponentScalingBehavior());
        await parent2.ensureAdd(ScoreComponentScalingBehavior());
      },
      verify: (game, _) async {
        final scoreComponents =
            game.descendants().whereType<ScoreComponent>().toList();
        game.update(1);

        expect(
          scoreComponents[0].scale.x,
          greaterThan(scoreComponents[1].scale.x),
        );
        expect(
          scoreComponents[0].scale.y,
          greaterThan(scoreComponents[1].scale.y),
        );
      },
    );
  });
}
