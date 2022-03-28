import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class FlipperTracingGame extends BasicGame with TapDetector {
  static const info = '''
      Basic example of how a Flipper works.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    final leftFlipper = Flipper(side: BoardSide.left)..initialPosition = center;

    await add(leftFlipper);
    leftFlipper.trace();
  }

  @override
  void onTapUp(TapUpInfo info) {
    add(
      Ball(baseColor: Colors.yellow)..initialPosition = info.eventPosition.game,
    );
  }
}

extension on BodyComponent {
  void trace({Color color = Colors.red}) {
    paint = Paint()..color = color;
    renderBody = true;
    body.joints.whereType<RevoluteJoint>().forEach(
          (joint) => joint.setLimits(0, 0),
        );

    for (final fixture in body.fixtures) {
      fixture.setSensor(true);
    }

    unawaited(
      mounted.whenComplete(() {
        final sprite = children.whereType<SpriteComponent>().first;
        sprite.paint.color = sprite.paint.color.withOpacity(0.5);
      }),
    );
  }
}
