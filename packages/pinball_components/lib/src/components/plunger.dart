import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template plunger}
/// [Plunger] serves as a spring, that shoots the ball on the right side of the
/// playfield.
///
/// [Plunger] ignores gravity so the player controls its downward [pull].
/// {@endtemplate}
class Plunger extends BodyComponent with InitialPosition, Layered {
  /// {@macro plunger}
  Plunger({
    required this.compressionDistance,
    // TODO(ruimiguel): set to priority +1 over LaunchRamp once all priorities
    // are fixed.
  }) : super(
          priority: RenderPriority.plunger,
          renderBody: false,
        ) {
    layer = Layer.launcher;
  }

  /// Distance the plunger can lower.
  final double compressionDistance;

  late final _PlungerSpriteAnimationGroupComponent _spriteComponent;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final leftShapeVertices = [
      Vector2(0, 0),
      Vector2(-1.8, 0),
      Vector2(-1.8, -2.2),
      Vector2(0, -0.3),
    ]..map((vector) => vector.rotate(BoardDimensions.perspectiveAngle))
        .toList();
    final leftTriangleShape = PolygonShape()..set(leftShapeVertices);

    final leftTriangleFixtureDef = FixtureDef(leftTriangleShape)..density = 80;
    fixturesDef.add(leftTriangleFixtureDef);

    final rightShapeVertices = [
      Vector2(0, 0),
      Vector2(1.8, 0),
      Vector2(1.8, -2.2),
      Vector2(0, -0.3),
    ]..map((vector) => vector.rotate(BoardDimensions.perspectiveAngle))
        .toList();
    final rightTriangleShape = PolygonShape()..set(rightShapeVertices);

    final rightTriangleFixtureDef = FixtureDef(rightTriangleShape)
      ..density = 80;
    fixturesDef.add(rightTriangleFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      userData: this,
      type: BodyType.dynamic,
      gravityScale: Vector2.zero(),
    );

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);
    return body;
  }

  /// Set a constant downward velocity on the [Plunger].
  void pull() {
    body.linearVelocity = Vector2(0, 7);
    _spriteComponent.pull();
  }

  /// Set an upward velocity on the [Plunger].
  ///
  /// The velocity's magnitude depends on how far the [Plunger] has been pulled
  /// from its original [initialPosition].
  void release() {
    final velocity = (initialPosition.y - body.position.y) * 5;
    body.linearVelocity = Vector2(0, velocity);
    _spriteComponent.release();
  }

  /// Anchors the [Plunger] to the [PrismaticJoint] that controls its vertical
  /// motion.
  Future<void> _anchorToJoint() async {
    final anchor = PlungerAnchor(plunger: this);
    await add(anchor);

    final jointDef = PlungerAnchorPrismaticJointDef(
      plunger: this,
      anchor: anchor,
    );

    world.createJoint(
      PrismaticJoint(jointDef)..setLimits(-compressionDistance, 0),
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _anchorToJoint();

    _spriteComponent = _PlungerSpriteAnimationGroupComponent();
    await add(_spriteComponent);
  }
}

/// Animation states associated with a [Plunger].
enum _PlungerAnimationState {
  /// Pull state.
  pull,

  /// Release state.
  release,
}

/// Animations for pulling and releasing [Plunger].
class _PlungerSpriteAnimationGroupComponent
    extends SpriteAnimationGroupComponent<_PlungerAnimationState>
    with HasGameRef {
  _PlungerSpriteAnimationGroupComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(1.87, 14.9),
        );

  void pull() {
    if (current != _PlungerAnimationState.pull) {
      animation?.reset();
    }
    current = _PlungerAnimationState.pull;
  }

  void release() {
    if (current != _PlungerAnimationState.release) {
      animation?.reset();
    }
    current = _PlungerAnimationState.release;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // TODO(alestiago): Used cached images.
    final spriteSheet = await gameRef.images.load(
      Assets.images.plunger.plunger.keyName,
    );

    const amountPerRow = 20;
    const amountPerColumn = 1;

    final textureSize = Vector2(
      spriteSheet.width / amountPerRow,
      spriteSheet.height / amountPerColumn,
    );
    size = textureSize / 10;

    // TODO(ruimiguel): we only need plunger pull animation, and release is just
    // to reverse it, so we need to divide by 2 while we don't have only half of
    // the animation (but amountPerRow and amountPerColumn needs to be correct
    // in order of calculate textureSize correctly).

    final pullAnimation = SpriteAnimation.fromFrameData(
      spriteSheet,
      SpriteAnimationData.sequenced(
        amount: amountPerRow * amountPerColumn ~/ 2,
        amountPerRow: amountPerRow ~/ 2,
        stepTime: 1 / 24,
        textureSize: textureSize,
        texturePosition: Vector2.zero(),
        loop: false,
      ),
    );

    animations = {
      _PlungerAnimationState.release: pullAnimation.reversed(),
      _PlungerAnimationState.pull: pullAnimation,
    };
    current = _PlungerAnimationState.release;
  }
}

/// {@template plunger_anchor}
/// [JointAnchor] positioned below a [Plunger].
/// {@endtemplate}
class PlungerAnchor extends JointAnchor {
  /// {@macro plunger_anchor}
  PlungerAnchor({
    required Plunger plunger,
  }) {
    initialPosition = Vector2(
      0,
      plunger.compressionDistance,
    );
  }
}

/// {@template plunger_anchor_prismatic_joint_def}
/// [PrismaticJointDef] between a [Plunger] and an [JointAnchor] with motion on
/// the vertical axis.
///
/// The [Plunger] is constrained vertically between its starting position and
/// the [JointAnchor]. The [JointAnchor] must be below the [Plunger].
/// {@endtemplate}
class PlungerAnchorPrismaticJointDef extends PrismaticJointDef {
  /// {@macro plunger_anchor_prismatic_joint_def}
  PlungerAnchorPrismaticJointDef({
    required Plunger plunger,
    required PlungerAnchor anchor,
  }) {
    initialize(
      plunger.body,
      anchor.body,
      plunger.body.position + anchor.body.position,
      Vector2(18.6, BoardDimensions.bounds.height),
    );
    enableLimit = true;
    lowerTranslation = double.negativeInfinity;
    enableMotor = true;
    motorSpeed = 1000;
    maxMotorForce = motorSpeed;
    collideConnected = true;
  }
}
