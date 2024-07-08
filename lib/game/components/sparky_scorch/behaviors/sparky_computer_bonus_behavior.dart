import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// Adds a [GameBonus.sparkyTurboCharge] when a [Ball] enters the
/// [SparkyComputer].
class SparkyComputerBonusBehavior extends Component
    with ParentIsA<SparkyScorch>, FlameBlocReader<GameBloc, GameState> {
  @override
  void onMount() {
    super.onMount();
    final sparkyComputer = parent.firstChild<SparkyComputer>()!;
    sparkyComputer.bloc.stream.listen((state) async {
      final listenWhen = state == SparkyComputerState.withBall;
      if (!listenWhen) return;

      bloc.add(const BonusActivated(GameBonus.sparkyTurboCharge));
    });
  }
}
