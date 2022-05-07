import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_components/pinball_components.dart';

/// Updates the launch [Ball] to reflect character selections.
class BallThemingBehavior extends Component
    with
        FlameBlocListenable<CharacterThemeCubit, CharacterThemeState>,
        HasGameRef {
  @override
  void onNewState(CharacterThemeState state) {
    gameRef
        .descendants()
        .whereType<Ball>()
        .single
        .bloc
        .onThemeChanged(state.characterTheme);
  }
}
