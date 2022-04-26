import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class MultipliersGame extends BallGame with KeyboardEvents {
  MultipliersGame() : super(color: const Color(0xFF009900));

  static const description = '''
    Shows how the Multipliers are rendered.
      
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press digits 2 to 6 for toggle state multipliers 2 to 6.
''';

  late final MultiplierSpriteGroupComponent x2;
  late final MultiplierSpriteGroupComponent x3;
  late final MultiplierSpriteGroupComponent x4;
  late final MultiplierSpriteGroupComponent x5;
  late final MultiplierSpriteGroupComponent x6;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.multiplier.x2.active.keyName,
      Assets.images.multiplier.x2.inactive.keyName,
      Assets.images.multiplier.x3.active.keyName,
      Assets.images.multiplier.x3.inactive.keyName,
      Assets.images.multiplier.x4.active.keyName,
      Assets.images.multiplier.x4.inactive.keyName,
      Assets.images.multiplier.x5.active.keyName,
      Assets.images.multiplier.x5.inactive.keyName,
      Assets.images.multiplier.x6.active.keyName,
      Assets.images.multiplier.x6.inactive.keyName,
    ]);

    camera.followVector2(Vector2.zero());
    x2 = MultiplierSpriteGroupComponent(
      position: Vector2(-20, 0),
      onAssetPath: Assets.images.multiplier.x2.active.keyName,
      offAssetPath: Assets.images.multiplier.x2.inactive.keyName,
    );

    x3 = MultiplierSpriteGroupComponent(
      position: Vector2(20, -5),
      onAssetPath: Assets.images.multiplier.x3.active.keyName,
      offAssetPath: Assets.images.multiplier.x3.inactive.keyName,
    );

    x4 = MultiplierSpriteGroupComponent(
      position: Vector2(0, -15),
      onAssetPath: Assets.images.multiplier.x4.active.keyName,
      offAssetPath: Assets.images.multiplier.x4.inactive.keyName,
    );

    x5 = MultiplierSpriteGroupComponent(
      position: Vector2(-10, -25),
      onAssetPath: Assets.images.multiplier.x5.active.keyName,
      offAssetPath: Assets.images.multiplier.x5.inactive.keyName,
    );

    x6 = MultiplierSpriteGroupComponent(
      position: Vector2(10, -35),
      onAssetPath: Assets.images.multiplier.x6.active.keyName,
      offAssetPath: Assets.images.multiplier.x6.inactive.keyName,
    );

    await addAll([x2, x3, x4, x5, x6]);
    await traceAllBodies();
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.digit2) {
        x2.toggle();
      }
      if (event.logicalKey == LogicalKeyboardKey.digit3) {
        x3.toggle();
      }
      if (event.logicalKey == LogicalKeyboardKey.digit4) {
        x4.toggle();
      }
      if (event.logicalKey == LogicalKeyboardKey.digit5) {
        x5.toggle();
      }
      if (event.logicalKey == LogicalKeyboardKey.digit6) {
        x6.toggle();
      }

      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

extension on MultiplierSpriteGroupComponent {
  void toggle() {
    if (current == MultiplierSpriteState.active) {
      current = MultiplierSpriteState.inactive;
    } else {
      current = MultiplierSpriteState.active;
    }
  }
}
