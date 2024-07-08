import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

class PlungerJointingBehavior extends Component with ParentIsA<Plunger> {
  PlungerJointingBehavior({required double compressionDistance})
      : _compressionDistance = compressionDistance;

  final double _compressionDistance;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final anchor = JointAnchor()
      ..initialPosition = Vector2(0, _compressionDistance);
    await add(anchor);

    final jointDef = _PlungerAnchorPrismaticJointDef(
      plunger: parent,
      anchor: anchor,
    );

    parent.world.createJoint(
      PrismaticJoint(jointDef)..setLimits(-_compressionDistance, 0),
    );
  }
}

/// [PrismaticJointDef] between a [Plunger] and an [JointAnchor] with motion on
/// the vertical axis.
///
/// The [Plunger] is constrained vertically between its starting position and
/// the [JointAnchor]. The [JointAnchor] must be below the [Plunger].
class _PlungerAnchorPrismaticJointDef extends PrismaticJointDef {
  /// {@macro plunger_anchor_prismatic_joint_def}
  _PlungerAnchorPrismaticJointDef({
    required Plunger plunger,
    required BodyComponent anchor,
  }) {
    initialize(
      plunger.body,
      anchor.body,
      plunger.body.position + anchor.body.position,
      Vector2(16, BoardDimensions.bounds.height),
    );
    enableLimit = true;
    lowerTranslation = double.negativeInfinity;
    enableMotor = true;
    motorSpeed = 1000;
    maxMotorForce = motorSpeed;
    collideConnected = true;
  }
}
