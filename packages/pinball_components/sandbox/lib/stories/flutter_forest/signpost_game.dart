import 'dart:async';

import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SignpostGame extends BasicBallGame with Traceable, TapDetector {
  static const info = '''
    Shows how a Signpost is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap to progress the sprite.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.signpost.inactive.keyName,
      Assets.images.signpost.active1.keyName,
      Assets.images.signpost.active2.keyName,
      Assets.images.signpost.active3.keyName,
    ]);

    camera.followVector2(Vector2.zero());
    await add(Signpost());
    await traceAllBodies();
  }

  @override
  void onTap() {
    super.onTap();
    firstChild<Signpost>()!.progress();
  }
}
