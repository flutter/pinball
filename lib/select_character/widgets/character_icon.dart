import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

/// {@template character_icon}
/// Widget for displaying character icon.
///
/// On tap changes selected character in [CharacterThemeCubit].
/// {@endtemplate}
class CharacterIcon extends StatelessWidget {
  /// {@macro character_icon}

  const CharacterIcon(
    CharacterTheme characterTheme, {
    Key? key,
  })  : _characterTheme = characterTheme,
        super(key: key);

  final CharacterTheme _characterTheme;

  @override
  Widget build(BuildContext context) {
    final currentCharacterTheme =
        context.select<CharacterThemeCubit, CharacterTheme>(
      (cubit) => cubit.state.characterTheme,
    );

    return GestureDetector(
      onTap: () => context
          .read<CharacterThemeCubit>()
          .characterSelected(_characterTheme),
      child: Opacity(
        opacity: currentCharacterTheme == _characterTheme ? 1 : 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: _characterTheme.icon.image(
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
