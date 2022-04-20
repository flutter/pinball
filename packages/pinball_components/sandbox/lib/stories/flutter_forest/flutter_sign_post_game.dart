import 'dart:async';

import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class FlutterSignPostGame extends BasicBallGame with Traceable, TapDetector {
  static const info = '''
    Shows how a FlutterSignPost is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap to progress the sprite.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await Future.wait([
      loadSprite(Assets.images.signPost.inactive.keyName),
      loadSprite(Assets.images.signPost.active1.keyName),
      loadSprite(Assets.images.signPost.active2.keyName),
      loadSprite(Assets.images.signPost.active3.keyName),
    ]);

    camera.followVector2(Vector2.zero());
    await add(FlutterSignPost()..priority = 1);
    await traceAllBodies();
  }

  @override
  void onTap() {
    super.onTap();
    firstChild<FlutterSignPost>()!.progress();
  }
}
