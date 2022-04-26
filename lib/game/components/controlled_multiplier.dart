import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template multipliers_group_component}
/// A [SpriteGroupComponent] for the multiplier over the board.
/// {@endtemplate}
class MultipliersGroup extends Component
    with Controls<_MultipliersController>, HasGameRef<PinballGame> {
  /// {@macro multipliers_group_component}
  MultipliersGroup() : super() {
    controller = _MultipliersController(this);
  }

  late final Multiplier _x2multiplier;

  late final Multiplier _x3multiplier;

  late final Multiplier _x4multiplier;

  late final Multiplier _x5multiplier;

  late final Multiplier _x6multiplier;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _x2multiplier = Multiplier(
      value: 2,
      position: Vector2(-19.5, -2),
      rotation: -15 * math.pi / 180,
    );

    _x3multiplier = Multiplier(
      value: 3,
      position: Vector2(13, -9.5),
      rotation: 15 * math.pi / 180,
    );

    _x4multiplier = Multiplier(
      value: 4,
      position: Vector2(0, -21),
    );

    _x5multiplier = Multiplier(
      value: 5,
      position: Vector2(-8.5, -28),
      rotation: -3 * math.pi / 180,
    );

    _x6multiplier = Multiplier(
      value: 6,
      position: Vector2(10, -31),
      rotation: 8 * math.pi / 180,
    );

    await addAll([
      _x2multiplier,
      _x3multiplier,
      _x4multiplier,
      _x5multiplier,
      _x6multiplier,
    ]);
  }
}

class _MultipliersController extends ComponentController<MultipliersGroup>
    with BlocComponent<GameBloc, GameState>, HasGameRef<PinballGame> {
  _MultipliersController(MultipliersGroup multipliersGroup)
      : super(multipliersGroup);

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    // TODO(ruimiguel): use here GameState.multiplier when merged
    // https://github.com/VGVentures/pinball/pull/213.
    return previousState?.score != newState.score;
  }

  @override
  void onNewState(GameState state) {
    // TODO(ruimiguel): use here GameState.multiplier when merged
    // https://github.com/VGVentures/pinball/pull/213.
    final currentMultiplier = state.score.bitLength % 6 + 1;

    component._x2multiplier.toggle(currentMultiplier);
    component._x3multiplier.toggle(currentMultiplier);
    component._x4multiplier.toggle(currentMultiplier);
    component._x5multiplier.toggle(currentMultiplier);
    component._x6multiplier.toggle(currentMultiplier);
  }
}
