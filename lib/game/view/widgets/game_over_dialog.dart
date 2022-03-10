import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

/// {@template game_over_dialog}
/// [Dialog] displayed when the [PinballGame] is over.
/// {@endtemplate}
class GameOverDialog extends StatelessWidget {
  /// {@macro game_over_dialog}
  const GameOverDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Text('Game Over'),
        ),
      ),
    );
  }
}
