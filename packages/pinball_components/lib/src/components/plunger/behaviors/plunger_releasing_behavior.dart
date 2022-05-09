import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';

class PlungerReleasingBehavior extends Component
    with FlameBlocListenable<PlungerCubit, PlungerState> {
  PlungerReleasingBehavior({
    required double strength,
  })  : assert(strength >= 0, "Strength can't be negative."),
        _strength = strength;

  final double _strength;

  late final Plunger _plunger;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _plunger = parent!.parent! as Plunger;
  }

  @override
  void onNewState(PlungerState state) {
    super.onNewState(state);
    if (state.isReleasing) {
      final velocity =
          (_plunger.initialPosition.y - _plunger.body.position.y) * _strength;
      _plunger.body.linearVelocity = Vector2(0, velocity);
    }
  }
}
