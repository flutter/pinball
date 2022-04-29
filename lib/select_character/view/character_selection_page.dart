// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_theme/pinball_theme.dart';
import 'package:pinball_ui/pinball_ui.dart';

class CharacterSelectionDialog extends StatelessWidget {
  const CharacterSelectionDialog({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const CharacterSelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CharacterThemeCubit(),
      child: const CharacterSelectionView(),
    );
  }
}

class CharacterSelectionView extends StatelessWidget {
  const CharacterSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PixelatedDecoration(
      header: Text(
        l10n.characterSelectionTitle,
        style: Theme.of(context).textTheme.headline3,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _CharacterSelectionGridView(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO(arturplaczek): remove after merge StarBlocListener
                final height = MediaQuery.of(context).size.height * 0.5;
                showDialog<void>(
                  context: context,
                  builder: (_) => Center(
                    child: SizedBox(
                      height: height,
                      width: height * 1.4,
                      child: HowToPlayDialog(),
                    ),
                  ),
                );
              },
              child: Text(l10n.start),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterSelectionGridView extends StatelessWidget {
  const _CharacterSelectionGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: const [
          CharacterImageButton(
            DashTheme(),
            key: Key('characterSelectionPage_dashButton'),
          ),
          CharacterImageButton(
            SparkyTheme(),
            key: Key('characterSelectionPage_sparkyButton'),
          ),
          CharacterImageButton(
            AndroidTheme(),
            key: Key('characterSelectionPage_androidButton'),
          ),
          CharacterImageButton(
            DinoTheme(),
            key: Key('characterSelectionPage_dinoButton'),
          ),
        ],
      ),
    );
  }
}

// TODO(allisonryan0002): remove visibility when adding final UI.
@visibleForTesting
class CharacterImageButton extends StatelessWidget {
  const CharacterImageButton(
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: (currentCharacterTheme == characterTheme)
              ? Colors.blue.withOpacity(0.5)
              : null,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: characterTheme.icon.image(),
        ),
      ),
    );
  }
}
