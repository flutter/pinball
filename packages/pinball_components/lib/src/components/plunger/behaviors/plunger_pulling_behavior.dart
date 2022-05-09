import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

class PlungerPullingBehavior extends Component
    with FlameBlocReader<PlungerCubit, PlungerState> {
  PlungerPullingBehavior({
    required double strength,
  }) : _strength = strength;

  final double _strength;

  late final Plunger _plunger;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _plunger = parent!.parent! as Plunger;
  }

  @override
  void update(double dt) {
    if (bloc.state.isPulling) {
      _plunger.body.linearVelocity = Vector2(0, _strength.abs());
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

    final joint = _plunger.body.joints.whereType<PrismaticJoint>().single;
    final reachedBottom = joint.getJointTranslation() <= joint.getLowerLimit();
    if (reachedBottom) {
      bloc.released();
    }
  }
}
