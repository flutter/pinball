import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Adds a [GameBonus.androidSpaceship] when [AndroidSpaceship] has a bonus.
class AndroidSpaceshipBonusBehavior extends Component
    with ParentIsA<AndroidAcres>, FlameBlocReader<GameBloc, GameState> {
  @override
  void onMount() {
    super.onMount();
    final androidSpaceship = parent.firstChild<AndroidSpaceship>()!;
    androidSpaceship.bloc.stream.listen((state) {
      final listenWhen = state == AndroidSpaceshipState.withBonus;
      if (!listenWhen) return;

      bloc.add(const BonusActivated(GameBonus.androidSpaceship));
      androidSpaceship.bloc.onBonusAwarded();
    });
  }
}
