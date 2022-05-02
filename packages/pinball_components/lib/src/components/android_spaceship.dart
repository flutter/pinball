// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class AndroidSpaceship extends Component {
  AndroidSpaceship({required Vector2 position})
      : super(
          children: [
            _SpaceshipSaucer()..initialPosition = position,
            _SpaceshipSaucerSpriteAnimationComponent()..position = position,
            _LightBeamSpriteComponent()..position = position + Vector2(2.5, 5),
            _AndroidHead()..initialPosition = position + Vector2(0.5, 0.25),
            _SpaceshipHole(
              outsideLayer: Layer.spaceshipExitRail,
              outsidePriority: ZIndexes.ballOnSpaceshipRail,
            )..initialPosition = position - Vector2(5.3, -5.4),
            _SpaceshipHole(
              outsideLayer: Layer.board,
              outsidePriority: ZIndexes.ballOnBoard,
            )..initialPosition = position - Vector2(-7.5, -1.1),
          ],
        );
}

class _SpaceshipSaucer extends BodyComponent with InitialPosition, Layered {
  _SpaceshipSaucer() : super(renderBody: false) {
    layer = Layer.spaceship;
  }

  @override
  Body createBody() {
    final shape = _SpaceshipSaucerShape();
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
      angle: -1.7,
    );

    return world.createBody(bodyDef)..createFixtureFromShape(shape);
  }
}

class _SpaceshipSaucerShape extends ChainShape {
  _SpaceshipSaucerShape() {
    const minorRadius = 9.75;
    const majorRadius = 11.9;

    createChain(
      [
        for (var angle = 0.2618; angle <= 6.0214; angle += math.pi / 180)
          Vector2(
            minorRadius * math.cos(angle),
            majorRadius * math.sin(angle),
          ),
      ],
    );
  }
}

class _SpaceshipSaucerSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameRef, ZIndex {
  _SpaceshipSaucerSpriteAnimationComponent()
      : super(
          anchor: Anchor.center,
        ) {
    zIndex = ZIndexes.spaceshipSaucer;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      Assets.images.android.spaceship.saucer.keyName,
    );

    const amountPerRow = 5;
    const amountPerColumn = 3;
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
      ),
    );
  }
}

// TODO(allisonryan0002): add pulsing behavior.
class _LightBeamSpriteComponent extends SpriteComponent
    with HasGameRef, ZIndex {
  _LightBeamSpriteComponent()
      : super(
          anchor: Anchor.center,
        ) {
    zIndex = ZIndexes.spaceshipLightBeam;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.android.spaceship.lightBeam.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _AndroidHead extends BodyComponent with InitialPosition, Layered, ZIndex {
  _AndroidHead()
      : super(
          children: [_AndroidHeadSpriteAnimationComponent()],
          renderBody: false,
        ) {
    layer = Layer.spaceship;
    zIndex = ZIndexes.androidHead;
  }

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: 3.1,
      minorRadius: 2,
    )..rotate(1.4);
    final bodyDef = BodyDef(position: initialPosition);

    return world.createBody(bodyDef)..createFixtureFromShape(shape);
  }
}

class _AndroidHeadSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameRef {
  _AndroidHeadSpriteAnimationComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-0.24, -2.6),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      Assets.images.android.spaceship.animatronic.keyName,
    );

    const amountPerRow = 18;
    const amountPerColumn = 4;
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
      ),
    );
  }
}

class _SpaceshipHole extends LayerSensor {
  _SpaceshipHole({required Layer outsideLayer, required int outsidePriority})
      : super(
          insideLayer: Layer.spaceship,
          outsideLayer: outsideLayer,
          orientation: LayerEntranceOrientation.down,
          insideZIndex: ZIndexes.ballOnSpaceship,
          outsideZIndex: outsidePriority,
        ) {
    layer = Layer.spaceship;
  }

  @override
  Shape get shape {
    return ArcShape(
      center: Vector2(0, -3.2),
      arcRadius: 5,
      angle: 1,
      rotation: -2,
    );
  }
}
