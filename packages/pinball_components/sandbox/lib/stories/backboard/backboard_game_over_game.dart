import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_theme/pinball_theme.dart';
import 'package:sandbox/common/common.dart';

class BackboardGameOverGame extends AssetsGame
    with HasKeyboardHandlerComponents {
  BackboardGameOverGame(this.score, this.character)
      : super(
          imagesFileNames: characterIconPaths.values.toList(),
        );

  static const description = '''
      Shows how the Backboard in game over mode is rendered.

      - Select a character to update the character icon.
  ''';

  static final characterIconPaths = <String, String>{
    'Dash': Assets.images.dash.leaderboardIcon.keyName,
    'Sparky': Assets.images.sparky.leaderboardIcon.keyName,
    'Android': Assets.images.android.leaderboardIcon.keyName,
    'Dino': Assets.images.dino.leaderboardIcon.keyName,
  };

  final int score;

  final String character;

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
