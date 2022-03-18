import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template game_over_dialog}
/// [Dialog] displayed when the [PinballGame] is over.
/// {@endtemplate}
class GameOverDialog extends StatelessWidget {
  /// {@macro game_over_dialog}
  const GameOverDialog({Key? key, required this.score, required this.theme})
      : super(key: key);

  final int score;
  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Game Over'),
              Text('Congratulations! your score is $score'),
              TextButton(
                onPressed: () {
                  //TODO: navigate to LeadersboardPage
                },
                child: const Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
