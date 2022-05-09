import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/google_rollover/behaviors/behaviors.dart';

/// {@template google_rollover}
/// Rollover that lights up [GoogleLetter]s.
/// {@endtemplate}
class GoogleRollover extends BodyComponent {
  /// {@macro google_rollover}
  GoogleRollover({
    required BoardSide side,
    Iterable<Component>? children,
  })  : _side = side,
        super(
          renderBody: false,
          children: [
            GoogleRolloverBallContactBehavior(),
            _RolloverDecalSpriteComponent(side: side),
            _PinSpriteAnimationComponent(side: side),
            ...?children,
          ],
        );

  final BoardSide _side;

  @override
  Body createBody() {
    final shape = PolygonShape()
      ..setAsBox(
        0.1,
        3.4,
        Vector2(_side.isLeft ? -14.8 : 5.9, -11),
        0.19 * _side.direction,
      );
    final fixtureDef = FixtureDef(shape, isSensor: true);
    return world.createBody(BodyDef())..createFixture(fixtureDef);
  }
}

class _RolloverDecalSpriteComponent extends SpriteComponent with HasGameRef {
  _RolloverDecalSpriteComponent({required BoardSide side})
      : _side = side,
        super(
          anchor: Anchor.center,
          position: Vector2(side.isLeft ? -14.8 : 5.9, -11),
          angle: 0.18 * side.direction,
        );

  final BoardSide _side;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        (_side.isLeft)
            ? Assets.images.googleRollover.left.decal.keyName
            : Assets.images.googleRollover.right.decal.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 20;
  }
}

class _PinSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameRef {
  _PinSpriteAnimationComponent({required BoardSide side})
      : _side = side,
        super(
          anchor: Anchor.center,
          position: Vector2(side.isLeft ? -14.9 : 5.95, -11),
          angle: 0,
          playing: false,
        );

  final BoardSide _side;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      _side.isLeft
          ? Assets.images.googleRollover.left.pin.keyName
          : Assets.images.googleRollover.right.pin.keyName,
    );

    const amountPerRow = 3;
    const amountPerColumn = 1;
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
