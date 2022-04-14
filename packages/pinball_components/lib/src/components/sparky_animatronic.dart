import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_animatronic}
/// Animated Sparky that sits on top of the [SparkyComputer].
/// {@endtemplate}
class SparkyAnimatronic extends SpriteAnimationComponent with HasGameRef {
  /// {@macro sparky_animatronic}
  SparkyAnimatronic()
      : super(
          anchor: Anchor.center,
          playing: false,
          priority: SpaceshipRamp.ballPriorityInsideRamp + 2,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = await gameRef.images.load(
      Assets.images.sparky.animatronic.keyName,
    );

    const amountPerRow = 8;
    const amountPerColumn = 6;
    final textureSize = Vector2(
      spriteSheet.width / amountPerRow,
      spriteSheet.height / amountPerColumn,
    );
    size = textureSize / 10;

    animation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: amountPerRow * amountPerColumn,
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
