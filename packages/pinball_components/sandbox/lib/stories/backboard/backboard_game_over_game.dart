import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_theme/pinball_theme.dart';
import 'package:sandbox/common/common.dart';

class BackboardGameOverGame extends BasicKeyboardGame {
  BackboardGameOverGame(this.score, this.character);

  static const info = '''
      Simple example showing the game over mode of the backboard.

      - Select a character to update the character icon.
  ''';

  final int score;
  final String character;

  static final characterIconPaths = <String, String>{
    'Dash': Assets.images.dash.leaderboardIcon.keyName,
    'Sparky': Assets.images.sparky.leaderboardIcon.keyName,
    'Android': Assets.images.android.leaderboardIcon.keyName,
    'Dino': Assets.images.dino.leaderboardIcon.keyName,
  };

  @override
  Future<void> onLoad() async {
    camera
      ..followVector2(Vector2.zero())
      ..zoom = 5;

    await images.loadAll(characterIconPaths.values.toList());

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
