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
        height: 250,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game Over',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Your score is $score',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 15,
                ),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your initials',
                  ),
                  maxLength: 3,
                ),
                const SizedBox(
                  height: 10,
                ),
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
      ),
    );
  }
}
