// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// Indicates the state of the arrow on the [SpaceshipRamp].
enum SpaceshipRampArrowSpriteState {
  /// Arrow with no dashes lit up.
  inactive,

  /// Arrow with 1 dash lit up.
  active1,

  /// Arrow with 2 dashes lit up.
  active2,

  /// Arrow with 3 dashes lit up.
  active3,

  /// Arrow with 4 dashes lit up.
  active4,

  /// Arrow with all 5 dashes lit up.
  active5,
}

extension on SpaceshipRampArrowSpriteState {
  String get path {
    switch (this) {
      case SpaceshipRampArrowSpriteState.inactive:
        return Assets.images.spaceship.ramp.arrow.inactive.keyName;
      case SpaceshipRampArrowSpriteState.active1:
        return Assets.images.spaceship.ramp.arrow.oneActive.keyName;
      case SpaceshipRampArrowSpriteState.active2:
        return Assets.images.spaceship.ramp.arrow.twoActive.keyName;
      case SpaceshipRampArrowSpriteState.active3:
        return Assets.images.spaceship.ramp.arrow.threeActive.keyName;
      case SpaceshipRampArrowSpriteState.active4:
        return Assets.images.spaceship.ramp.arrow.fourActive.keyName;
      case SpaceshipRampArrowSpriteState.active5:
        return Assets.images.spaceship.ramp.arrow.fiveActive.keyName;
    }
  }

  SpaceshipRampArrowSpriteState get next {
    return SpaceshipRampArrowSpriteState
        .values[(index + 1) % SpaceshipRampArrowSpriteState.values.length];
  }
}

/// {@template spaceship_ramp}
/// A [Blueprint] which creates the ramp leading into the [Spaceship].
/// {@endtemplate}
class SpaceshipRamp extends Forge2DBlueprint {
  /// {@macro spaceship_ramp}
  SpaceshipRamp();

  /// [SpriteGroupComponent] representing the arrow that lights up.
  late final SpaceshipRampArrowSpriteComponent spaceshipRampArrow;

  /// Forwards the sprite to the next [SpaceshipRampArrowSpriteState].
  ///
  /// If the current state is the last one it cycles back to the initial state.
  void progress() => spaceshipRampArrow.progress();

  @override
  void build(_) {
    addAllContactCallback([
      LayerSensorBallContactCallback<_SpaceshipRampOpening>(),
    ]);

    final rightOpening = _SpaceshipRampOpening(
      outsidePriority: RenderPriority.ballOnBoard,
      rotation: -5 * math.pi / 180,
    )
      ..initialPosition = Vector2(1.7, -20.2)
      ..layer = Layer.opening;
    final leftOpening = _SpaceshipRampOpening(
      outsideLayer: Layer.spaceship,
      outsidePriority: RenderPriority.ballOnSpaceship,
      rotation: -5 * math.pi / 180,
    )
      ..initialPosition = Vector2(-13.7, -19)
      ..layer = Layer.spaceshipEntranceRamp;

    final spaceshipRamp = _SpaceshipRampBackground();

    spaceshipRampArrow = SpaceshipRampArrowSpriteComponent();

    final spaceshipRampBoardOpeningSprite =
        _SpaceshipRampBoardOpeningSpriteComponent()
          ..position = Vector2(3.4, -39.5);

    final spaceshipRampForegroundRailing = _SpaceshipRampForegroundRailing();

    final baseRight = _SpaceshipRampBase()..initialPosition = Vector2(1.7, -20);

    addAll([
      spaceshipRampBoardOpeningSprite,
      rightOpening,
      leftOpening,
      baseRight,
      _SpaceshipRampBackgroundRailingSpriteComponent(),
      spaceshipRamp,
      spaceshipRampArrow,
      spaceshipRampForegroundRailing,
    ]);
  }
}

class _SpaceshipRampBackground extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipRampBackground()
      : super(
          priority: RenderPriority.spaceshipRamp,
          children: [
            _SpaceshipRampBackgroundRampSpriteComponent(),
          ],
        ) {
    layer = Layer.spaceshipEntranceRamp;
    renderBody = false;
  }

  /// Width between walls of the ramp.
  static const width = 5.0;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final outerLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-30.75, -37.3),
        Vector2(-32.5, -71.25),
        Vector2(-14.2, -71.25),
      ],
    );
    final outerLeftCurveFixtureDef = FixtureDef(outerLeftCurveShape);
    fixturesDef.add(outerLeftCurveFixtureDef);

    final outerRightCurveShape = BezierCurveShape(
      controlPoints: [
        outerLeftCurveShape.vertices.last,
        Vector2(2.5, -71.9),
        Vector2(6.1, -44.9),
      ],
    );
    final outerRightCurveFixtureDef = FixtureDef(outerRightCurveShape);
    fixturesDef.add(outerRightCurveFixtureDef);

    final boardOpeningEdgeShape = EdgeShape()
      ..set(
        outerRightCurveShape.vertices.last,
        Vector2(7.3, -41.1),
      );
    final boardOpeningEdgeShapeFixtureDef = FixtureDef(boardOpeningEdgeShape);
    fixturesDef.add(boardOpeningEdgeShapeFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _SpaceshipRampBackgroundRailingSpriteComponent extends SpriteComponent
    with HasGameRef {
  _SpaceshipRampBackgroundRailingSpriteComponent()
      : super(
          position: Vector2(-11.7, -54.3),
          priority: RenderPriority.spaceshipRampBackgroundRailing,
        );
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.spaceship.ramp.railingBackground.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
  }
}

class _SpaceshipRampBackgroundRampSpriteComponent extends SpriteComponent
    with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.spaceship.ramp.main.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(-10.7, -53.6);
  }
}

/// {@template spaceship_ramp_arrow_sprite_component}
/// An arrow inside [SpaceshipRamp].
///
/// Lights up a each dash whenever a [Ball] gets into [SpaceshipRamp].
/// {@endtemplate}
class SpaceshipRampArrowSpriteComponent
    extends SpriteGroupComponent<SpaceshipRampArrowSpriteState>
    with HasGameRef {
  /// {@macro spaceship_ramp_arrow_sprite_component}
  SpaceshipRampArrowSpriteComponent()
      : super(
          position: Vector2(-3.9, -56.5),
          priority: RenderPriority.spaceshipRampBackgroundRailing,
        );

  /// Changes arrow image to the next [Sprite].
  void progress() => current = current?.next;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprites = <SpaceshipRampArrowSpriteState, Sprite>{};
    this.sprites = sprites;
    for (final spriteState in SpaceshipRampArrowSpriteState.values) {
      sprites[spriteState] = await gameRef.loadSprite(spriteState.path);
    }

    current = SpaceshipRampArrowSpriteState.inactive;
    size = sprites[current]!.originalSize / 10;
    anchor = Anchor.center;
  }
}

class _SpaceshipRampBoardOpeningSpriteComponent extends SpriteComponent
    with HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.spaceship.ramp.boardOpening.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
  }
}

class _SpaceshipRampForegroundRailing extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipRampForegroundRailing()
      : super(
          priority: RenderPriority.spaceshipRampForegroundRailing,
          children: [_SpaceshipRampForegroundRailingSpriteComponent()],
        ) {
    layer = Layer.spaceshipEntranceRamp;
    renderBody = false;
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final innerLeftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(-24.5, -38),
        Vector2(-26.3, -64),
        Vector2(-13.8, -64.5),
      ],
    );

    final innerLeftCurveFixtureDef = FixtureDef(innerLeftCurveShape);
    fixturesDef.add(innerLeftCurveFixtureDef);

    final innerRightCurveShape = BezierCurveShape(
      controlPoints: [
        innerLeftCurveShape.vertices.last,
        Vector2(-2.5, -66.2),
        Vector2(0, -44.5),
      ],
    );

    final innerRightCurveFixtureDef = FixtureDef(innerRightCurveShape);
    fixturesDef.add(innerRightCurveFixtureDef);

    final boardOpeningEdgeShape = EdgeShape()
      ..set(
        innerRightCurveShape.vertices.last,
        Vector2(-0.85, -40.8),
      );
    final boardOpeningEdgeShapeFixtureDef = FixtureDef(boardOpeningEdgeShape);
    fixturesDef.add(boardOpeningEdgeShapeFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _SpaceshipRampForegroundRailingSpriteComponent extends SpriteComponent
    with HasGameRef {
  _SpaceshipRampForegroundRailingSpriteComponent()
      : super(
          position: Vector2(-12.3, -52.5),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.spaceship.ramp.railingForeground.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
  }
}

class _SpaceshipRampBase extends BodyComponent with InitialPosition, Layered {
  _SpaceshipRampBase() {
    renderBody = false;
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
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
    );

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
        ) {
    renderBody = false;
  }

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
