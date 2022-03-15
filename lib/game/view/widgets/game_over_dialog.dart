import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/leaderboard/leader_board.dart';

/// {@template game_over_dialog}
/// [Dialog] displayed when the [PinballGame] is over.
/// {@endtemplate}
class GameOverDialog extends StatelessWidget {
  /// {@macro game_over_dialog}
  const GameOverDialog({Key? key}) : super(key: key);

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
                  LeaderBoardPage.route(),
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
