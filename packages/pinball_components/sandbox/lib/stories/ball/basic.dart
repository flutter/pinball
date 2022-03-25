import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BasicBallGame extends BasicGame with TapDetector {
  BasicBallGame({required this.color});

  static const info = '''
      Basic example of how a Ball works, tap anywhere on the
      screen to spawn a ball into the game.
''';

  final Color color;

  @override
  void onTapUp(TapUpInfo info) {
    add(
      Ball(baseColor: color)..initialPosition = info.eventPosition.game,
    );
  }
}
