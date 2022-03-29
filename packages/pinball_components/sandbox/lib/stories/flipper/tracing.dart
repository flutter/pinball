import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class FlipperTracingGame extends BasicGame {
  static const info = '''
      Basic example of how the Flipper body overlays the sprite.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final center = screenToWorld(camera.viewport.canvasSize! / 2);

    final leftFlipper = Flipper(side: BoardSide.left)
      ..initialPosition = center - Vector2(Flipper.size.x, 0);
    final rightFlipper = Flipper(side: BoardSide.right)
      ..initialPosition = center + Vector2(Flipper.size.x, 0);

    await addAll([
      leftFlipper,
      rightFlipper,
    ]);
    leftFlipper.trace();
    rightFlipper.trace();
  }
}

extension on BodyComponent {
  void trace({Color color = Colors.red}) {
    paint = Paint()..color = color;
    renderBody = true;
    body.joints.whereType<RevoluteJoint>().forEach(
          (joint) => joint.setLimits(0, 0),
        );
    body.setType(BodyType.static);

    unawaited(
      mounted.whenComplete(() {
        final sprite = children.whereType<SpriteComponent>().first;
        sprite.paint.color = sprite.paint.color.withOpacity(0.5);
      }),
    );
  }
}
