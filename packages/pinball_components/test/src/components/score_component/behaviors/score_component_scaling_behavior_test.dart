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

    flameTester.test('can be loaded', (game) async {
      final parent = ScoreComponent.test(
        points: Points.fiveThousand,
        position: Vector2.zero(),
        effectController: EffectController(duration: 1),
      );
      final behavior = ScoreComponentScalingBehavior();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);

      expect(parent.children, contains(behavior));
    });

    flameTester.test(
      'scales the sprite',
      (game) async {
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
        game.update(1);

        expect(
          parent1.scale.x,
          greaterThan(parent2.scale.x),
        );
        expect(
          parent1.scale.y,
          greaterThan(parent2.scale.y),
        );
      },
    );
  });
}
