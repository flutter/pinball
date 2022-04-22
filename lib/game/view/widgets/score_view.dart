// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_components/pinball_components.dart';

class ScoreView extends StatelessWidget {
  const ScoreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isGameOver = context.select((GameBloc bloc) => bloc.state.isGameOver);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: isGameOver ? const _GameOver() : const _ScoreWidget(),
      ),
    );
  }
}

class _GameOver extends StatelessWidget {
  const _GameOver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Text(
      l10n.gameOver,
      style: AppTextStyle.headline1.copyWith(
        color: AppColors.white,
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.score.toLowerCase(),
          style: AppTextStyle.subtitle1.copyWith(
            color: AppColors.orange,
          ),
        ),
        const _ScoreText(),
        const ScoreBalls(),
      ],
    );
  }
}

class _ScoreText extends StatelessWidget {
  const _ScoreText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = context.select((GameBloc bloc) => bloc.state.score);

    return Text(
      score.formatScore(),
      style: AppTextStyle.headline1.copyWith(
        color: AppColors.white,
      ),
    );
  }
}
