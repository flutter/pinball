import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:platform_helper/platform_helper.dart';

/// Updates the [ArcadeBackground] and launch [Ball] to reflect character
/// selections.
class CharacterSelectionBehavior extends Component
    with
        FlameBlocListenable<CharacterThemeCubit, CharacterThemeState>,
        HasGameRef {
  @override
  void onNewState(CharacterThemeState state) {
    if (!readProvider<PlatformHelper>().isMobile) {
      gameRef
          .descendants()
          .whereType<ArcadeBackground>()
          .single
          .bloc
          .onCharacterSelected(state.characterTheme);
    }
    gameRef
        .descendants()
        .whereType<Ball>()
        .single
        .bloc
        .onCharacterSelected(state.characterTheme);
  }
}
