import 'dart:async';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/flipper/basic_flipper_game.dart';

class FlipperTracingGame extends BasicFlipperGame {
  static const info = '''
    Basic example of how the Flipper body overlays the sprite.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    leftFlipper.trace();
    leftFlipper.body.joints.whereType<RevoluteJoint>().forEach(
          (joint) => joint.setLimits(0, 0),
        );

    rightFlipper.trace();
    rightFlipper.body.joints.whereType<RevoluteJoint>().forEach(
          (joint) => joint.setLimits(0, 0),
        );
  }
}
