// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
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

class _MockSpriteAnimation extends Mock implements SpriteAnimation {
  @override
  SpriteAnimationTicker createTicker() {
    return _MockSpriteAnimationTicker();
  }
}

class _MockSpriteAnimationTicker extends Mock implements SpriteAnimationTicker {
  @override
  Sprite getSprite() {
    return _MockSprite();
  }
}

class _MockSprite extends Mock implements Sprite {
  @override
  Vector2 get srcSize => Vector2.zero();
}

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

    flameTester.testGameWidget(
      'can be added',
      setUp: (game, tester) async {
        final behavior = AnimatronicLoopingBehavior(animationCoolDown: 1);
        final animation = _MockSpriteAnimation();
        final spriteAnimationComponent = _TestSpriteAnimationComponent()
          ..animation = animation;
        await game.ensureAdd(spriteAnimationComponent);
        await spriteAnimationComponent.add(behavior);
      },
      verify: (game, _) async {
        final spriteAnimationComponent =
            game.children.whereType<_TestSpriteAnimationComponent>().single;
        expect(spriteAnimationComponent, isNotNull);
        expect(
          spriteAnimationComponent
              .descendants()
              .whereType<AnimatronicLoopingBehavior>()
              .length,
          1,
        );
      },
    );

    flameTester.testGameWidget(
      'onTick starts playing the animation',
      setUp: (game, _) async {
        final behavior = AnimatronicLoopingBehavior(animationCoolDown: 1);
        final spriteAnimationComponent = _TestSpriteAnimationComponent();
        await game.ensureAdd(spriteAnimationComponent);
        await spriteAnimationComponent.add(behavior);
        spriteAnimationComponent.playing = false;
      },
      verify: (game, tester) async {
        final spriteAnimationComponent =
            game.children.whereType<_TestSpriteAnimationComponent>().single;
        final behavior = spriteAnimationComponent
            .descendants()
            .whereType<AnimatronicLoopingBehavior>()
            .single;
        game.update(behavior.timer.limit);
        expect(spriteAnimationComponent.playing, isTrue);
      },
    );

    flameTester.testGameWidget(
      'animation onComplete resets and stops playing the animation',
      setUp: (game, _) async {
        await game.onLoad();
        final behavior = AnimatronicLoopingBehavior(animationCoolDown: 1);
        final spriteAnimationComponent = DashAnimatronic();

        await game.ensureAdd(spriteAnimationComponent);
        await spriteAnimationComponent.add(behavior);
      },
      verify: (game, _) async {
        final spriteAnimationComponent =
            game.children.whereType<DashAnimatronic>().single;
        game.update(1);
        expect(spriteAnimationComponent.playing, isTrue);

        spriteAnimationComponent.animationTicker!.onComplete!.call();

        expect(spriteAnimationComponent.playing, isFalse);
        expect(
          spriteAnimationComponent.animationTicker!.currentIndex,
          equals(0),
        );
      },
    );

    flameTester.testGameWidget(
      'animation onComplete resets and starts the timer',
      setUp: (game, _) async {
        await game.onLoad();
        final behavior = AnimatronicLoopingBehavior(animationCoolDown: 1);
        final spriteAnimationComponent = DashAnimatronic();

        await spriteAnimationComponent.add(behavior);
        await game.ensureAdd(spriteAnimationComponent);
      },
      verify: (game, _) async {
        final spriteAnimationComponent =
            game.children.whereType<DashAnimatronic>().single;
        final behavior = spriteAnimationComponent
            .descendants()
            .whereType<AnimatronicLoopingBehavior>()
            .single;
        game.update(0.5);
        expect(behavior.timer.current, equals(0.5));

        spriteAnimationComponent.animationTicker!.onComplete!.call();

        expect(behavior.timer.current, equals(0));
        expect(behavior.timer.isRunning(), isTrue);
      },
    );
  });
}
