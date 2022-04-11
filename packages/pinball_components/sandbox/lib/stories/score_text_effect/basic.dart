import 'dart:math';

import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class ScoreTextEffectBasicGame extends BasicGame with TapDetector {
  static const info = '''
      Simple game to show how score text effects works,
      simply tap on the screen to spawn an effect on the given location.
  ''';

  final random = Random();

  @override
  Future<void> onLoad() async {
    camera.followVector2(Vector2.zero());
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(
      ScoreTextEffect(
        text: random.nextInt(100000).toString(),
        color: Colors.white,
        position: info.eventPosition.game..multiply(Vector2(1, -1)),
      ),
    );
  }
}
