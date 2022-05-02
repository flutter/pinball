import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class GoogleLetterGame extends BallGame {
  GoogleLetterGame()
      : super(
          color: const Color(0xFF009900),
          imagesFileNames: [
            Assets.images.googleWord.letter1.lit.keyName,
            Assets.images.googleWord.letter1.dimmed.keyName,
          ],
        );

  static const description = '''
    Shows how a GoogleLetter is rendered.
      
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(GoogleLetter(0));

    await traceAllBodies();
  }
}
