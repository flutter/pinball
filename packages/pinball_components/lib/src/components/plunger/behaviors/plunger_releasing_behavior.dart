import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class PlungerReleasingBehavior extends Component
    with ParentIsA<Plunger>, FlameBlocListenable<PlungerCubit, PlungerState> {
  PlungerReleasingBehavior({
    required double strength,
  }) : _strength = strength;

  final double _strength; // 11

  @override
  void onNewState(PlungerState state) {
    super.onNewState(state);
    if (state.isReleasing) {
      final velocity =
          (parent.initialPosition.y - parent.body.position.y) * _strength;
      parent.body.linearVelocity = Vector2(0, velocity);
    }
  }
}
