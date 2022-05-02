import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template sparky_animatronic}
/// Animated Sparky that sits on top of the [SparkyComputer].
/// {@endtemplate}
class SparkyAnimatronic extends SpriteAnimationComponent
    with HasGameRef, ZIndex {
  /// {@macro sparky_animatronic}
  SparkyAnimatronic()
      : super(
          anchor: Anchor.center,
          playing: false,
        ) {
    zIndex = ZIndexes.sparkyAnimatronic;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      Assets.images.sparky.animatronic.keyName,
    );

    const amountPerRow = 9;
    const amountPerColumn = 7;
    final textureSize = Vector2(
      spriteSheet.width / amountPerRow,
      spriteSheet.height / amountPerColumn,
    );
    size = textureSize / 10;

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: (amountPerRow * amountPerColumn) - 1,
        amountPerRow: amountPerRow,
        stepTime: 1 / 24,
        textureSize: textureSize,
        loop: false,
      ),
    )..onComplete = () {
        animation?.reset();
        playing = false;
      };
  }
}
