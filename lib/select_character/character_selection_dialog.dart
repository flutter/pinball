// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_theme/pinball_theme.dart' hide Assets;
import 'package:pinball_ui/pinball_ui.dart';

class CharacterSelectionDialog extends StatelessWidget {
  const CharacterSelectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CharacterSelectionView();
  }
}

class CharacterSelectionView extends StatelessWidget {
  const CharacterSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PixelatedDecoration(
      header: const _CharacterSelectionTitle(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 20),
          Expanded(child: _CharacterSelectionBody()),
          _SelectCharacter(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _CharacterSelectionTitle extends StatelessWidget {
  const _CharacterSelectionTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.characterSelectionTitle,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyle.headline2.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBlue,
          ),
        ),
        Text(
          l10n.characterSelectionSubtitle,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyle.headline2.copyWith(
            color: AppColors.darkBlue,
          ),
        ),
      ],
    );
  }
}

class _CharacterSelectionBody extends StatelessWidget {
  const _CharacterSelectionBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 32);

    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: padding,
            child: Center(child: SelectedCharacter()),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StarAnimation.starA(),
              const Padding(
                padding: padding,
                child: _CharacterSelection(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CharacterSelection extends StatelessWidget {
  const _CharacterSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      children: const [
        CharacterIcon(
          DashTheme(),
          key: Key('characterSelectionPage_dashButton'),
        ),
        CharacterIcon(
          SparkyTheme(),
          key: Key('characterSelectionPage_sparkyButton'),
        ),
        CharacterIcon(
          AndroidTheme(),
          key: Key('characterSelectionPage_androidButton'),
        ),
        CharacterIcon(
          DinoTheme(),
          key: Key('characterSelectionPage_dinoButton'),
        ),
      ],
    );
  }
}

class _SelectCharacter extends StatelessWidget {
  const _SelectCharacter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(flex: 5),
        const _SelectCharacterButton(),
        const Spacer(flex: 2),
        StarAnimation.starA(),
        const Spacer(flex: 2),
      ],
    );
  }
}

class _SelectCharacterButton extends StatelessWidget {
  const _SelectCharacterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PinballButton(
      child: Text(
        l10n.select,
        style: AppTextStyle.headline3,
      ),
      onPressed: () {
        context.read<StartGameBloc>().add(const CharacterSelected());
        Navigator.of(context).pop();
      },
    );
  }
}
