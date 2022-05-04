import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/flapper/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template flapper}
/// Flap to let a [Ball] out of the [LaunchRamp] and to prevent [Ball]s from
/// going back in.
/// {@endtemplate}
class Flapper extends Component {
  /// {@macro flapper}
  Flapper()
      : super(
          children: [
            FlapperEntrance(
              children: [
                FlapperSpinningBehavior(),
              ],
            )..initialPosition = Vector2(4, -69.3),
            _FlapperStructure(),
            _FlapperExit()..initialPosition = Vector2(-0.6, -33.8),
            _BackSupportSpriteComponent(),
            _FrontSupportSpriteComponent(),
            FlapSpriteAnimationComponent(),
          ],
        );

  /// Creates a [Flapper] without any children.
  ///
  /// This can be used for testing [Flapper]'s behaviors in isolation.
  @visibleForTesting
  Flapper.test();
}

/// {@template flapper_entrance}
/// Sensor used in [FlapperSpinningBehavior] to animate
/// [FlapSpriteAnimationComponent].
/// {@endtemplate}
class FlapperEntrance extends BodyComponent with InitialPosition, Layered {
  /// {@macro flapper_entrance}
  FlapperEntrance({
    Iterable<Component>? children,
  }) : super(
          children: children,
          renderBody: false,
        ) {
    layer = Layer.launcher;
  }

  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(
        Vector2.zero(),
        Vector2(0, 3.2),
      );
    final fixtureDef = FixtureDef(
      shape,
      isSensor: true,
    );
    final bodyDef = BodyDef(position: initialPosition);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class _FlapperStructure extends BodyComponent with Layered {
  _FlapperStructure() : super(renderBody: false) {
    layer = Layer.board;
  }

  List<FixtureDef> _createFixtureDefs() {
    final leftEdgeShape = EdgeShape()
      ..set(
        Vector2(1.9, -69.3),
        Vector2(1.9, -66),
      );

    final bottomEdgeShape = EdgeShape()
      ..set(
        leftEdgeShape.vertex2,
        Vector2(3.9, -66),
      );

    return [
      FixtureDef(leftEdgeShape),
      FixtureDef(bottomEdgeShape),
    ];
  }

  @override
  Body createBody() {
    final body = world.createBody(BodyDef());
    _createFixtureDefs().forEach(body.createFixture);
    return body;
  }
}

class _FlapperExit extends LayerSensor {
  _FlapperExit()
      : super(
          insideLayer: Layer.launcher,
          outsideLayer: Layer.board,
          orientation: LayerEntranceOrientation.down,
          insideZIndex: ZIndexes.ballOnLaunchRamp,
          outsideZIndex: ZIndexes.ballOnBoard,
        ) {
    layer = Layer.launcher;
  }

  @override
  Shape get shape => PolygonShape()
    ..setAsBox(
      1.7,
      0.1,
      initialPosition,
      1.5708,
    );
}

/// {@template flap_sprite_animation_component}
/// Flap suspended between supports that animates to let the [Ball] exit the
/// [LaunchRamp].
/// {@endtemplate}
@visibleForTesting
class FlapSpriteAnimationComponent extends SpriteAnimationComponent
    with HasGameRef, ZIndex {
  /// {@macro flap_sprite_animation_component}
  FlapSpriteAnimationComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(2.8, -70.7),
          playing: false,
        ) {
    zIndex = ZIndexes.flapper;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final spriteSheet = gameRef.images.fromCache(
      Assets.images.flapper.flap.keyName,
    );

    const amountPerRow = 14;
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

class _BackSupportSpriteComponent extends SpriteComponent
    with HasGameRef, ZIndex {
  _BackSupportSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(2.95, -70.6),
        ) {
    zIndex = ZIndexes.flapperBack;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.flapper.backSupport.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _FrontSupportSpriteComponent extends SpriteComponent
    with HasGameRef, ZIndex {
  _FrontSupportSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(2.9, -67.6),
        ) {
    zIndex = ZIndexes.flapperFront;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.flapper.frontSupport.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
