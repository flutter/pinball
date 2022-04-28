import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';

/// {@template round_count_display}
/// Colored square indicating if a round is available.
/// {@endtemplate}
class RoundCountDisplay extends StatelessWidget {
  /// {@macro round_count_display}
  const RoundCountDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rounds = context.select((GameBloc bloc) => bloc.state.rounds);

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
            RoundIndicator(isActive: rounds >= 1),
            RoundIndicator(isActive: rounds >= 2),
            RoundIndicator(isActive: rounds >= 3),
          ],
        ),
      ],
    );
  }
}

/// {@template round_indicator}
/// [Widget] that displays the round indicator.
/// {@endtemplate}
@visibleForTesting
class RoundIndicator extends StatelessWidget {
  /// {@macro round_indicator}
  const RoundIndicator({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  /// A value that describes whether the indicator is active.
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
