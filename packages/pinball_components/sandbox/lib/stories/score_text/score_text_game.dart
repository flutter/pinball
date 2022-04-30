import 'dart:math';

import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class ScoreTextGame extends AssetsGame with TapDetector {
  static const description = '''
    Simple game to show how score text works,

    - Tap anywhere on the screen to spawn an text on the given location.
''';

  final random = Random();

  @override
  Future<void> onLoad() async {
    camera.followVector2(Vector2.zero());
  }

  @override
  void onTapUp(TapUpInfo info) {
    final index = random.nextInt(Score.values.length);
    final score = Score.values[index];

    add(
      ScoreText(
        score: score,
        position: info.eventPosition.game..multiply(Vector2(1, -1)),
      ),
    );
  }
}
