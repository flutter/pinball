import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Joints the [Flipper] to allow pivoting around one end.
class FlipperJointingBehavior extends Component
    with ParentIsA<Flipper>, HasGameRef {
  late final RevoluteJoint _joint;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final anchor = _FlipperAnchor(flipper: parent);
    await add(anchor);

    final jointDef = _FlipperAnchorRevoluteJointDef(
      flipper: parent,
      anchor: anchor,
    );
    _joint = _FlipperJoint(jointDef);
    parent.world.createJoint(_joint);
  }

  @override
  void onMount() {
    gameRef.ready().whenComplete(
          () => parent.body.joints.whereType<_FlipperJoint>().first.unlock(),
        );
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
/// Hinges one end of [Flipper] to a [_FlipperAnchor] to achieve a potivoting
/// motion.
/// {@endtemplate}
class _FlipperAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro flipper_anchor_revolute_joint_def}
  _FlipperAnchorRevoluteJointDef({
    required Flipper flipper,
    required _FlipperAnchor anchor,
  }) : side = flipper.side {
    enableLimit = true;
    initialize(
      flipper.body,
      anchor.body,
      flipper.body.position + anchor.body.position,
    );
  }

  final BoardSide side;
}

/// {@template flipper_joint}
/// [RevoluteJoint] that controls the pivoting motion of a [Flipper].
/// {@endtemplate}
class _FlipperJoint extends RevoluteJoint {
  /// {@macro flipper_joint}
  _FlipperJoint(_FlipperAnchorRevoluteJointDef def)
      : side = def.side,
        super(def) {
    lock();
  }

  /// Half the angle of the arc motion.
  static const _halfSweepingAngle = 0.611;

  final BoardSide side;

  /// Locks the [Flipper] to its resting position.
  ///
  /// The joint is locked when initialized in order to force the [Flipper]
  /// at its resting position.
  void lock() {
    final angle = _halfSweepingAngle * side.direction;
    setLimits(angle, angle);
  }

  /// Unlocks the [Flipper] from its resting position.
  void unlock() {
    const angle = _halfSweepingAngle;
    setLimits(-angle, angle);
  }
}
