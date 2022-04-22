// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';

class ScoreBalls extends StatelessWidget {
  const ScoreBalls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final balls = context.select((GameBloc bloc) => bloc.state.balls);

    return Row(
      children: [
        Text(
          l10n.rounds,
          style: AppTextStyle.subtitle1.copyWith(
            color: AppColors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            ScoreBall(isActive: balls >= 1),
            ScoreBall(isActive: balls >= 2),
            ScoreBall(isActive: balls >= 3),
          ],
        ),
      ],
    );
  }
}

@visibleForTesting
class ScoreBall extends StatelessWidget {
  const ScoreBall({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.orange : AppColors.orange.withAlpha(128);
    const size = 8.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        color: color,
        height: size,
        width: size,
      ),
    );
  }
}
