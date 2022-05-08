import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class PlungerPullingBehavior extends Component
    with ParentIsA<Plunger>, FlameBlocReader<PlungerCubit, PlungerState> {
  PlungerPullingBehavior({
    required double strength,
  }) : _strength = strength;

  final double _strength;

  @override
  void update(double dt) {
    if (bloc.state.isPulling) {
      parent.body.linearVelocity = Vector2(0, _strength);
    }
  }
}

class PlungerAutoPullingBehavior extends PlungerPullingBehavior {
  PlungerAutoPullingBehavior({
    required double strength,
  }) : super(strength: strength);

  @override
  void update(double dt) {
    super.update(dt);

    final joint = parent.body.joints.whereType<PrismaticJoint>().single;
    final reachedBottom = joint.getJointTranslation() <= joint.getLowerLimit();
    if (reachedBottom) {
      bloc.released();
    }
  }
}
