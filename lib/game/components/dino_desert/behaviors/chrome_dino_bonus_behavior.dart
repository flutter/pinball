import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds a [GameBonus.dinoChomp] when a [Ball] is chomped by the [ChromeDino].
class ChromeDinoBonusBehavior extends Component
    with HasGameRef<PinballGame>, ParentIsA<DinoDesert> {
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

      gameRef.read<GameBloc>().add(const BonusActivated(GameBonus.dinoChomp));
    });
  }
}
