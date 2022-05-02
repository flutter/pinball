import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template chrome_dino_swivel_behavior}
/// Swivels the [ChromeDino] up and down periodically to match its animation
/// sequence.
/// {@endtemplate}
class ChromeDinoSwivelingBehavior extends TimerComponent
    with ParentIsA<ChromeDino> {
  /// {@macro chrome_dino_swivel_behavior}
  ChromeDinoSwivelingBehavior()
      : super(
          period: 98 / 48,
          repeat: true,
        );

  late final RevoluteJoint _joint;

  @override
  Future<void> onLoad() async {
    final anchor = _ChromeDinoAnchor()
      ..initialPosition = parent.initialPosition + Vector2(9, -4);
    await add(anchor);

    final jointDef = _ChromeDinoAnchorRevoluteJointDef(
      chromeDino: parent,
      anchor: anchor,
    );
    _joint = RevoluteJoint(jointDef);
    parent.world.createJoint(_joint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final angle = _joint.jointAngle();

    if (angle < _joint.upperLimit &&
        angle > _joint.lowerLimit &&
        parent.bloc.state.isMouthOpen) {
      parent.bloc.onCloseMouth();
    } else if ((angle >= _joint.upperLimit || angle <= _joint.lowerLimit) &&
        !parent.bloc.state.isMouthOpen) {
      parent.bloc.onOpenMouth();
    }
  }

  @override
  void onTick() {
    super.onTick();
    _joint.setMotorSpeed(-_joint.motorSpeed);
  }
}

class _ChromeDinoAnchor extends JointAnchor
    with ParentIsA<ChromeDinoSwivelingBehavior> {
  @override
  void onMount() {
    super.onMount();
    parent.parent.children
        .whereType<SpriteAnimationComponent>()
        .forEach((sprite) {
      sprite.animation!.currentIndex = 45;
      sprite.changeParent(this);
    });
  }
}

class _ChromeDinoAnchorRevoluteJointDef extends RevoluteJointDef {
  _ChromeDinoAnchorRevoluteJointDef({
    required ChromeDino chromeDino,
    required _ChromeDinoAnchor anchor,
  }) {
    initialize(
      chromeDino.body,
      anchor.body,
      chromeDino.body.position + anchor.body.position,
    );
    enableLimit = true;
    lowerAngle = -ChromeDino.halfSweepingAngle;
    upperAngle = ChromeDino.halfSweepingAngle;

    enableMotor = true;
    maxMotorTorque = chromeDino.body.mass * 255;
    motorSpeed = 2;
  }
}
