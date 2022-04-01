import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/stories/flipper/basic.dart';

class FlipperTracingGame extends BasicFlipperGame {
  static const info = '''
      Basic example of how the Flipper body overlays the sprite.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
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

    unawaited(
      mounted.whenComplete(() {
        final sprite = children.whereType<SpriteComponent>().first;
        sprite.paint.color = sprite.paint.color.withOpacity(0.5);
      }),
    );
  }
}
