// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.load(Assets.images.dash.animatronic.keyName);
  }
}

class _TestSpriteAnimationComponent extends SpriteAnimationComponent {}

class _MockSpriteAnimation extends Mock implements SpriteAnimation {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('AnimatronicLoopingBehavior', () {
    test('can be instantiated', () {
      expect(
        AnimatronicLoopingBehavior(animationCoolDown: 1),
        isA<AnimatronicLoopingBehavior>(),
      );
    });

    flameTester.test(
      'can be added',
      (game) async {
        final behavior = AnimatronicLoopingBehavior(animationCoolDown: 1);
        final animation = _MockSpriteAnimation();
        final spriteAnimationComponent = _TestSpriteAnimationComponent()
          ..animation = animation;
        await game.ensureAdd(spriteAnimationComponent);
        await spriteAnimationComponent.add(behavior);
        await game.ready();

        expect(game.contains(spriteAnimationComponent), isTrue);
        expect(spriteAnimationComponent.contains(behavior), isTrue);
      },
    );

    flameTester.test(
      'onTick starts playing the animation',
      (game) async {
        final behavior = AnimatronicLoopingBehavior(animationCoolDown: 1);
        final spriteAnimationComponent = _TestSpriteAnimationComponent();
        await game.ensureAdd(spriteAnimationComponent);
        await spriteAnimationComponent.add(behavior);

        spriteAnimationComponent.playing = false;
        game.update(behavior.timer.limit);

        expect(spriteAnimationComponent.playing, isTrue);
      },
    );

    flameTester.test(
      'animation onComplete resets and stops playing the animation',
      (game) async {
        final behavior = AnimatronicLoopingBehavior(animationCoolDown: 1);
        final spriteAnimationComponent = DashAnimatronic();

        await game.ensureAdd(spriteAnimationComponent);
        await spriteAnimationComponent.add(behavior);

        game.update(1);
        expect(spriteAnimationComponent.playing, isTrue);

        spriteAnimationComponent.animation!.onComplete!.call();

        expect(spriteAnimationComponent.playing, isFalse);
        expect(spriteAnimationComponent.animation!.currentIndex, equals(0));
      },
    );

    flameTester.test(
      'animation onComplete resets and starts the timer',
      (game) async {
        final behavior = AnimatronicLoopingBehavior(animationCoolDown: 1);
        final spriteAnimationComponent = DashAnimatronic();

        await game.ensureAdd(spriteAnimationComponent);
        await spriteAnimationComponent.add(behavior);

        game.update(0.5);
        expect(behavior.timer.current, equals(0.5));

        spriteAnimationComponent.animation!.onComplete!.call();

        expect(behavior.timer.current, equals(0));
        expect(behavior.timer.isRunning(), isTrue);
      },
    );
  });
}
