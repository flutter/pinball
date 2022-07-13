import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Bonus obtained at the [FlutterForest].
///
/// When all [DashBumper]s are hit at least once three times, the [Signpost]
/// progresses. When the [Signpost] fully progresses, the [GameBonus.dashNest]
/// is awarded, and the [DashBumper.main] releases a new [Ball].
class FlutterForestBonusBehavior extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocListener<SignpostCubit, SignpostState>(
        listenWhen: (_, state) => state == SignpostState.active3,
        onNewState: (_) {
          readBloc<GameBloc, GameState>()
              .add(const BonusActivated(GameBonus.dashNest));
          readBloc<SignpostCubit, SignpostState>().onProgressed();
          readBloc<DashBumpersCubit, DashBumpersState>().onReset();
          add(BonusBallSpawningBehavior());
        },
      ),
    );
  }
}
