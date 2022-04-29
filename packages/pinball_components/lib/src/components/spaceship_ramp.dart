import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// {@template spaceship_ramp}
/// A [Blueprint] which creates the ramp leading into the [AndroidSpaceship].
/// {@endtemplate}
class SpaceshipRamp extends Blueprint {
  /// {@macro spaceship_ramp}
  SpaceshipRamp()
      : super(
          components: [
            _SpaceshipRampOpening(
              outsidePriority: RenderPriority.ballOnBoard,
              rotation: math.pi,
            )
              ..initialPosition = Vector2(1.7, -19.8)
              ..layer = Layer.opening,
            _SpaceshipRampOpening(
              outsideLayer: Layer.spaceship,
              outsidePriority: RenderPriority.ballOnSpaceship,
              rotation: math.pi,
            )
              ..initialPosition = Vector2(-13.7, -18.6)
              ..layer = Layer.spaceshipEntranceRamp,
            _SpaceshipRampBackground(),
            _SpaceshipRampBoardOpeningSpriteComponent()
              ..position = Vector2(3.4, -39.5),
            _SpaceshipRampForegroundRailing(),
            _SpaceshipRampBase()..initialPosition = Vector2(1.7, -20),
            _SpaceshipRampBackgroundRailingSpriteComponent(),
            _SpaceshipRampArrowSpriteComponent(),
          ],
        );

  /// Forwards the sprite to the next [SpaceshipRampArrowSpriteState].
  ///
  /// If the current state is the last one it cycles back to the initial state.
  void progress() => components
      .whereType<_SpaceshipRampArrowSpriteComponent>()
      .first
      .progress();
}

/// Indicates the state of the arrow on the [SpaceshipRamp].
@visibleForTesting
enum SpaceshipRampArrowSpriteState {
  /// Arrow with no dashes lit up.
  inactive,

  /// Arrow with 1 light lit up.
  active1,

  /// Arrow with 2 lights lit up.
  active2,

  /// Arrow with 3 lights lit up.
  active3,

  /// Arrow with 4 lights lit up.
  active4,

  /// Arrow with all 5 lights lit up.
  active5,
}

extension on SpaceshipRampArrowSpriteState {
  String get path {
    switch (this) {
      case SpaceshipRampArrowSpriteState.inactive:
        return Assets.images.android.ramp.arrow.inactive.keyName;
      case SpaceshipRampArrowSpriteState.active1:
        return Assets.images.android.ramp.arrow.active1.keyName;
      case SpaceshipRampArrowSpriteState.active2:
        return Assets.images.android.ramp.arrow.active2.keyName;
      case SpaceshipRampArrowSpriteState.active3:
        return Assets.images.android.ramp.arrow.active3.keyName;
      case SpaceshipRampArrowSpriteState.active4:
        return Assets.images.android.ramp.arrow.active4.keyName;
      case SpaceshipRampArrowSpriteState.active5:
        return Assets.images.android.ramp.arrow.active5.keyName;
    }
  }

  SpaceshipRampArrowSpriteState get next {
    return SpaceshipRampArrowSpriteState
        .values[(index + 1) % SpaceshipRampArrowSpriteState.values.length];
  }
}

class _SpaceshipRampBackground extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipRampBackground()
      : super(
          priority: RenderPriority.spaceshipRamp,
          renderBody: false,
          children: [
            _SpaceshipRampBackgroundRampSpriteComponent(),
          ],
        ) {
    layer = Layer.spaceshipEntranceRamp;
  }

  /// Width between walls of the ramp.
  static const width = 5.0;

  List<FixtureDef> _createFixtureDefs() {
    final outerLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-30.75, -37.3),
        Vector2(-32.5, -71.25),
        Vector2(-14.2, -71.25),
      ],
    );
    final outerRightCurveShape = BezierCurveShape(
      controlPoints: [
        outerLeftCurveShape.vertices.last,
        Vector2(2.5, -71.9),
        Vector2(6.1, -44.9),
      ],
    );
    final boardOpeningEdgeShape = EdgeShape()
      ..set(
        outerRightCurveShape.vertices.last,
        Vector2(7.3, -41.1),
      );

    return [
      FixtureDef(outerRightCurveShape),
      FixtureDef(outerLeftCurveShape),
      FixtureDef(boardOpeningEdgeShape),
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(position: initialPosition);
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _SpaceshipRampBackgroundRailingSpriteComponent extends SpriteComponent
    with HasGameRef {
  _SpaceshipRampBackgroundRailingSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-11.7, -54.3),
          priority: RenderPriority.spaceshipRampBackgroundRailing,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.android.ramp.railingBackground.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _SpaceshipRampBackgroundRampSpriteComponent extends SpriteComponent
    with HasGameRef {
  _SpaceshipRampBackgroundRampSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-10.7, -53.6),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.android.ramp.main.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

/// {@template spaceship_ramp_arrow_sprite_component}
/// An arrow inside [SpaceshipRamp].
///
/// Lights progressively whenever a [Ball] gets into [SpaceshipRamp].
/// {@endtemplate}
class _SpaceshipRampArrowSpriteComponent
    extends SpriteGroupComponent<SpaceshipRampArrowSpriteState>
    with HasGameRef {
  /// {@macro spaceship_ramp_arrow_sprite_component}
  _SpaceshipRampArrowSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-3.9, -56.5),
          priority: RenderPriority.spaceshipRampArrow,
        );

  /// Changes arrow image to the next [Sprite].
  void progress() => current = current?.next;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprites = <SpaceshipRampArrowSpriteState, Sprite>{};
    this.sprites = sprites;
    for (final spriteState in SpaceshipRampArrowSpriteState.values) {
      sprites[spriteState] = Sprite(
        gameRef.images.fromCache(spriteState.path),
      );
    }

    current = SpaceshipRampArrowSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
  }
}

class _SpaceshipRampBoardOpeningSpriteComponent extends SpriteComponent
    with HasGameRef {
  _SpaceshipRampBoardOpeningSpriteComponent() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.android.ramp.boardOpening.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _SpaceshipRampForegroundRailing extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipRampForegroundRailing()
      : super(
          priority: RenderPriority.spaceshipRampForegroundRailing,
          renderBody: false,
          children: [_SpaceshipRampForegroundRailingSpriteComponent()],
        ) {
    layer = Layer.spaceshipEntranceRamp;
  }

  List<FixtureDef> _createFixtureDefs() {
    final innerLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-24.5, -38),
        Vector2(-26.3, -64),
        Vector2(-13.8, -64.5),
      ],
    );
    final innerRightCurveShape = BezierCurveShape(
      controlPoints: [
        innerLeftCurveShape.vertices.last,
        Vector2(-2.5, -66.2),
        Vector2(0, -44.5),
      ],
    );
    final boardOpeningEdgeShape = EdgeShape()
      ..set(
        innerRightCurveShape.vertices.last,
        Vector2(-0.85, -40.8),
      );

    return [
      FixtureDef(innerLeftCurveShape),
      FixtureDef(innerRightCurveShape),
      FixtureDef(boardOpeningEdgeShape),
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(position: initialPosition);
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _SpaceshipRampForegroundRailingSpriteComponent extends SpriteComponent
    with HasGameRef {
  _SpaceshipRampForegroundRailingSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-12.3, -52.5),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.android.ramp.railingForeground.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _SpaceshipRampBase extends BodyComponent with InitialPosition, Layered {
  _SpaceshipRampBase() : super(renderBody: false) {
    layer = Layer.board;
  }

  @override
  Body createBody() {
    const baseWidth = 9;
    final baseShape = BezierCurveShape(
      controlPoints: [
        Vector2(initialPosition.x - baseWidth / 2, initialPosition.y),
        Vector2(initialPosition.x - baseWidth / 2, initialPosition.y) +
            Vector2(2, -5),
        Vector2(initialPosition.x + baseWidth / 2, initialPosition.y) +
            Vector2(-2, -5),
        Vector2(initialPosition.x + baseWidth / 2, initialPosition.y)
      ],
    );
    final fixtureDef = FixtureDef(baseShape);
    final bodyDef = BodyDef(position: initialPosition);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template spaceship_ramp_opening}
/// [LayerSensor] with [Layer.spaceshipEntranceRamp] to filter [Ball] collisions
/// inside [_SpaceshipRampBackground].
/// {@endtemplate}
class _SpaceshipRampOpening extends LayerSensor {
  /// {@macro spaceship_ramp_opening}
  _SpaceshipRampOpening({
    Layer? outsideLayer,
    int? outsidePriority,
    required double rotation,
  })  : _rotation = rotation,
        super(
          insideLayer: Layer.spaceshipEntranceRamp,
          outsideLayer: outsideLayer,
          orientation: LayerEntranceOrientation.down,
          insidePriority: RenderPriority.ballOnSpaceshipRamp,
          outsidePriority: outsidePriority,
        );

  final double _rotation;

  static final Vector2 _size = Vector2(_SpaceshipRampBackground.width / 3, .1);

  @override
  Shape get shape {
    return PolygonShape()
      ..setAsBox(
        _size.x,
        _size.y,
        initialPosition,
        _rotation,
      );
  }
}
