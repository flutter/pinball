// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/leaderboard/leader_board.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template game_over_dialog}
/// [Dialog] displayed when the [PinballGame] is over.
/// {@endtemplate}
class GameOverDialog extends StatelessWidget {
  /// {@macro game_over_dialog}
  const GameOverDialog({Key? key, required this.theme}) : super(key: key);

  final PinballTheme theme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.gameOver),
              TextButton(
                onPressed: () => Navigator.of(context).push<void>(
                  LeaderBoardPage.route(theme: theme),
                ),
                child: Text(l10n.leadersBoard),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
