import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_components/src/components/spaceship_ramp/behavior/behavior.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/spaceship_ramp_cubit.dart';

/// {@template spaceship_ramp}
/// Ramp leading into the [AndroidSpaceship].
/// {@endtemplate}
class SpaceshipRamp extends Component {
  /// {@macro spaceship_ramp}
  SpaceshipRamp({
    Iterable<Component>? children,
  }) : this._(
          children: children,
          bloc: SpaceshipRampCubit(),
        );

  SpaceshipRamp._({
    Iterable<Component>? children,
    required this.bloc,
  }) : super(
          children: [
            _SpaceshipRampOpening(
              outsideLayer: Layer.spaceship,
              outsidePriority: ZIndexes.ballOnSpaceship,
              rotation: math.pi,
            )
              ..initialPosition = Vector2(-13.7, -18.6)
              ..layer = Layer.spaceshipEntranceRamp,
            _SpaceshipRampBackground(),
            SpaceshipRampBoardOpening()..initialPosition = Vector2(3.4, -39.5),
            _SpaceshipRampForegroundRailing(),
            SpaceshipRampBase()..initialPosition = Vector2(3.4, -42.5),
            _SpaceshipRampBackgroundRailingSpriteComponent(),
            SpaceshipRampArrowSpriteComponent(
              current: bloc.state.hits,
            ),
            ...?children,
          ],
        );

  /// Creates a [SpaceshipRamp] without any children.
  ///
  /// This can be used for testing [SpaceshipRamp]'s behaviors in isolation.
  @visibleForTesting
  SpaceshipRamp.test({
    required this.bloc,
  }) : super();

  final SpaceshipRampCubit bloc;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }
}

class _SpaceshipRampBackground extends BodyComponent
    with InitialPosition, Layered, ZIndex {
  _SpaceshipRampBackground()
      : super(
          renderBody: false,
          children: [
            _SpaceshipRampBackgroundRampSpriteComponent(),
          ],
        ) {
    layer = Layer.spaceshipEntranceRamp;
    zIndex = ZIndexes.spaceshipRamp;
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
    with HasGameRef, ZIndex {
  _SpaceshipRampBackgroundRailingSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-11.7, -54.3),
        ) {
    zIndex = ZIndexes.spaceshipRampBackgroundRailing;
  }

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
@visibleForTesting
class SpaceshipRampArrowSpriteComponent extends SpriteGroupComponent<int>
    with HasGameRef, ParentIsA<SpaceshipRamp>, ZIndex {
  /// {@macro spaceship_ramp_arrow_sprite_component}
  SpaceshipRampArrowSpriteComponent({
    required int current,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(-3.9, -56.5),
          current: current,
        ) {
    zIndex = ZIndexes.spaceshipRampArrow;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen((state) {
      current = state.hits % SpaceshipRampArrowSpriteState.values.length;
    });

    final sprites = <int, Sprite>{};
    this.sprites = sprites;
    for (final spriteState in SpaceshipRampArrowSpriteState.values) {
      sprites[spriteState.index] = Sprite(
        gameRef.images.fromCache(spriteState.path),
      );
    }

    current = 0;
    size = sprites[current]!.originalSize / 10;
  }
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
}

class SpaceshipRampBoardOpening extends BodyComponent
    with Layered, ZIndex, InitialPosition, ParentIsA<SpaceshipRamp> {
  SpaceshipRampBoardOpening()
      : super(
          renderBody: false,
          children: [
            _SpaceshipRampBoardOpeningSpriteComponent(),
            RampBallAscendingContactBehavior()..applyTo(['inside']),
            LayerContactBehavior(layer: Layer.spaceshipEntranceRamp)
              ..applyTo(['inside']),
            LayerContactBehavior(
              layer: Layer.board,
              onBegin: false,
            )..applyTo(['outside']),
            ZIndexContactBehavior(
              zIndex: ZIndexes.ballOnBoard,
              onBegin: false,
            )..applyTo(['outside']),
            ZIndexContactBehavior(zIndex: ZIndexes.ballOnSpaceshipRamp)
              ..applyTo(['middle', 'inside']),
          ],
        ) {
    zIndex = ZIndexes.spaceshipRampBoardOpening;
    layer = Layer.opening;
  }

  /// Creates a [SpaceshipRampBoardOpening] without any children.
  ///
  /// This can be used for testing [SpaceshipRampBoardOpening]'s behaviors in
  /// isolation.
  @visibleForTesting
  SpaceshipRampBoardOpening.test();

  List<FixtureDef> _createFixtureDefs() {
    final topEdge = EdgeShape()
      ..set(
        Vector2(-3.4, -1.2),
        Vector2(3.4, -1.6),
      );
    final bottomEdge = EdgeShape()
      ..set(
        Vector2(-6.2, 1.5),
        Vector2(6.2, 1.5),
      );
    final middleCurve = BezierCurveShape(
      controlPoints: [
        topEdge.vertex1,
        Vector2(0, 2.3),
        Vector2(7.5, 2.3),
        topEdge.vertex2,
      ],
    );
    final leftCurve = BezierCurveShape(
      controlPoints: [
        Vector2(-4.4, -1.2),
        Vector2(-4.65, 0),
        bottomEdge.vertex1,
      ],
    );
    final rightCurve = BezierCurveShape(
      controlPoints: [
        Vector2(4.4, -1.6),
        Vector2(4.65, 0),
        bottomEdge.vertex2,
      ],
    );

    const outsideKey = 'outside';
    return [
      FixtureDef(
        topEdge,
        isSensor: true,
        userData: 'inside',
      ),
      FixtureDef(
        bottomEdge,
        isSensor: true,
        userData: outsideKey,
      ),
      FixtureDef(
        middleCurve,
        isSensor: true,
        userData: 'middle',
      ),
      FixtureDef(
        leftCurve,
        isSensor: true,
        userData: outsideKey,
      ),
      FixtureDef(
        rightCurve,
        isSensor: true,
        userData: outsideKey,
      ),
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
    with InitialPosition, Layered, ZIndex {
  _SpaceshipRampForegroundRailing()
      : super(
          renderBody: false,
          children: [_SpaceshipRampForegroundRailingSpriteComponent()],
        ) {
    layer = Layer.spaceshipEntranceRamp;
    zIndex = ZIndexes.spaceshipRampForegroundRailing;
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

@visibleForTesting
class SpaceshipRampBase extends BodyComponent
    with InitialPosition, ContactCallbacks {
  SpaceshipRampBase() : super(renderBody: false);

  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    super.preSolve(other, contact, oldManifold);
    if (other is! Layered) return;
    // Although, the Layer should already be taking care of the contact
    // filtering, this is to ensure the ball doesn't collide with the ramp base
    // when the filtering is calculated on different time steps.
    contact.setEnabled(other.layer == Layer.board);
  }

  @override
  Body createBody() {
    final shape = BezierCurveShape(
      controlPoints: [
        Vector2(-4.25, 1.75),
        Vector2(-2, -2.1),
        Vector2(2, -2.3),
        Vector2(4.1, 1.5),
      ],
    );
    final bodyDef = BodyDef(position: initialPosition, userData: this);
    return world.createBody(bodyDef)..createFixtureFromShape(shape);
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
          insideZIndex: ZIndexes.ballOnSpaceshipRamp,
          outsideZIndex: outsidePriority,
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
