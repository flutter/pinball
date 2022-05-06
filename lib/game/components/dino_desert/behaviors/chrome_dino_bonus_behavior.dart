import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds a [GameBonus.dinoChomp] when a [Ball] is chomped by the [ChromeDino].
class ChromeDinoBonusBehavior extends Component
    with ParentIsA<DinoDesert>, FlameBlocReader<GameBloc, GameState> {
  @override
  void onMount() {
    super.onMount();
    final chromeDino = parent.firstChild<ChromeDino>()!;

    // TODO(alestiago): Refactor subscription management once the following is
    // merged:
    // https://github.com/flame-engine/flame/pull/1538
    chromeDino.bloc.stream.listen((state) {
      final listenWhen = state.status == ChromeDinoStatus.chomping;
      if (!listenWhen) return;

      bloc.add(const BonusActivated(GameBonus.dinoChomp));
    });
  }
}
