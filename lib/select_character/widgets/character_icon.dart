// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

class CharacterIcon extends StatelessWidget {
  const CharacterIcon(
    this.characterTheme, {
    Key? key,
  }) : super(key: key);

  final CharacterTheme characterTheme;

  @override
  Widget build(BuildContext context) {
    final currentCharacterTheme =
        context.select<CharacterThemeCubit, CharacterTheme>(
      (cubit) => cubit.state.characterTheme,
    );

    return GestureDetector(
      onTap: () =>
          context.read<CharacterThemeCubit>().characterSelected(characterTheme),
      child: Opacity(
        opacity: currentCharacterTheme == characterTheme ? 1 : 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: characterTheme.icon.image(
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
