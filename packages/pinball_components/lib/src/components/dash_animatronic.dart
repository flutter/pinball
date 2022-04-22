import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template dash_animatronic}
/// Animated Dash that sits on top of the [DashNestBumper.main].
/// {@endtemplate}
class DashAnimatronic extends SpriteAnimationComponent with HasGameRef {
  /// {@macro dash_animatronic}
  DashAnimatronic()
      : super(
          anchor: Anchor.center,
          playing: false,
          priority: RenderPriority.dashAnimatronic,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      Assets.images.dash.animatronic.keyName,
    );

    const amountPerRow = 13;
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
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (animation != null) {
      if (animation!.isLastFrame) {
        animation!.reset();
        playing = false;
      }
    }
  }
}
