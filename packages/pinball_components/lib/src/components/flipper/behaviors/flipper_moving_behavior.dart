import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';

class FlipperMovingBehavior extends Component
    with
        FlameBlocListenable<FlipperCubit, FlipperState>,
        FlameBlocReader<FlipperCubit, FlipperState> {
  FlipperMovingBehavior({
    required double strength,
  })  : assert(strength >= 0, "Strength can't be negative"),
        _strength = strength;

  final double _strength;

  late final Flipper _flipper;

  void _moveUp() => _flipper.body.linearVelocity = Vector2(0, -_strength);

  void _moveDown() => _flipper.body.linearVelocity = Vector2(0, _strength);

  @override
  void onNewState(FlipperState state) {
    super.onNewState(state);
    if (bloc.state.isMovingDown) _moveDown();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.isMovingUp) _moveUp();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _flipper = parent!.parent! as Flipper;
    _moveDown();
  }
}
