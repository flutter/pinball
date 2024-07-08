import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// Joints the [Flipper] to allow pivoting around one end.
class FlipperJointingBehavior extends Component
    with ParentIsA<Flipper>, HasGameRef {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final anchor = _FlipperAnchor(flipper: parent);
    await add(anchor);

    final jointDef = _FlipperAnchorRevoluteJointDef(
      flipper: parent,
      anchor: anchor,
    );
    parent.world.createJoint(RevoluteJoint(jointDef));
  }
}

/// {@template flipper_anchor}
/// [JointAnchor] positioned at the end of a [Flipper].
///
/// The end of a [Flipper] depends on its [Flipper.side].
/// {@endtemplate}
class _FlipperAnchor extends JointAnchor {
  /// {@macro flipper_anchor}
  _FlipperAnchor({
    required Flipper flipper,
  }) {
    initialPosition = Vector2(
      (Flipper.size.x * flipper.side.direction) / 2 -
          (1.65 * flipper.side.direction),
      -0.15,
    );
  }
}

/// {@template flipper_anchor_revolute_joint_def}
/// Hinges one end of [Flipper] to a [_FlipperAnchor] to achieve a pivoting
/// motion.
/// {@endtemplate}
class _FlipperAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro flipper_anchor_revolute_joint_def}
  _FlipperAnchorRevoluteJointDef({
    required Flipper flipper,
    required _FlipperAnchor anchor,
  }) {
    initialize(
      flipper.body,
      anchor.body,
      flipper.body.position + anchor.body.position,
    );

    enableLimit = true;
    upperAngle = 0.611;
    lowerAngle = -upperAngle;
  }
}
