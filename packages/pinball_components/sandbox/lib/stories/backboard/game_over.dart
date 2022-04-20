import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BackboardGameOverGame extends BasicKeyboardGame {
  BackboardGameOverGame(this.score, this.character);

  static const info = '''
      Simple example showing the game over mode of the backboard.

      - Select a character to update the character icon.
  ''';

  final int score;
  final String character;

  final characterIconPaths = <String, String>{
    'Dash': 'packages/pinball_theme/assets/images/dash/leaderboard_icon.png',
    'Sparky':
        'packages/pinball_theme/assets/images/sparky/leaderboard_icon.png',
    'Android':
        'packages/pinball_theme/assets/images/android/leaderboard_icon.png',
    'Dino': 'packages/pinball_theme/assets/images/dino/leaderboard_icon.png',
  };

  @override
  Future<void> onLoad() async {
    camera
      ..followVector2(Vector2.zero())
      ..zoom = 5;

    await add(
      Backboard.gameOver(
        position: Vector2(0, 20),
        score: score,
        characterIconPath: characterIconPaths[character]!,
        onSubmit: (initials) {
          add(
            ScoreText(
              text: 'User $initials made $score',
              position: Vector2(0, 50),
              color: Colors.pink,
            ),
          );
        },
      ),
    );
  }
}
