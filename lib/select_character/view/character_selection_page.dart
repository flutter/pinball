import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_theme/pinball_theme.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template character_selection_dialog}
/// Dialog used to select the playing character of the game.
/// {@endtemplate character_selection_dialog}
class CharacterSelectionDialog extends StatelessWidget {
  /// {@macro character_selection_dialog}
  const CharacterSelectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PinballDialog(
      title: l10n.characterSelectionTitle,
      subtitle: l10n.characterSelectionSubtitle,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(child: _CharacterPreview()),
                  Expanded(child: _CharacterGrid()),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const _SelectCharacterButton(),
          ],
        ),
      ),
    );
  }
}

class _SelectCharacterButton extends StatelessWidget {
  const _SelectCharacterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PinballButton(
      onTap: () async {
        Navigator.of(context).pop();
        context.read<StartGameBloc>().add(const CharacterSelected());
      },
      text: l10n.select,
    );
  }
}

class _CharacterGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterThemeCubit, CharacterThemeState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                _Character(
                  key: const Key('sparky_character_selection'),
                  character: const SparkyTheme(),
                  isSelected: state.isSparkySelected,
                ),
                const SizedBox(height: 6),
                _Character(
                  key: const Key('android_character_selection'),
                  character: const AndroidTheme(),
                  isSelected: state.isAndroidSelected,
                ),
              ],
            ),
            const SizedBox(width: 6),
            Column(
              children: [
                _Character(
                  key: const Key('dash_character_selection'),
                  character: const DashTheme(),
                  isSelected: state.isDashSelected,
                ),
                const SizedBox(height: 6),
                _Character(
                  key: const Key('dino_character_selection'),
                  character: const DinoTheme(),
                  isSelected: state.isDinoSelected,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _CharacterPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterThemeCubit, CharacterThemeState>(
      builder: (context, state) {
        return SelectedCharacter(currentCharacter: state.characterTheme);
      },
    );
  }
}

class _Character extends StatelessWidget {
  const _Character({
    Key? key,
    required this.character,
    required this.isSelected,
  }) : super(key: key);

  final CharacterTheme character;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Opacity(
        opacity: isSelected ? 1 : 0.3,
        child: TextButton(
          onPressed: () =>
              context.read<CharacterThemeCubit>().characterSelected(character),
          child: character.icon.image(fit: BoxFit.contain),
        ),
      ),
    );
  }
}
