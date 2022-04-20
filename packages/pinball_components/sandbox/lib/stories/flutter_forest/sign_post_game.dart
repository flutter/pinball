import 'dart:async';

import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SignPostGame extends BasicBallGame with Traceable, TapDetector {
  static const info = '''
    Shows how a SignPost is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap to progress the sprite.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(SignPost()..priority = 1);
    await traceAllBodies();
  }

  @override
  void onTap() {
    super.onTap();
    firstChild<SignPost>()!.progress();
  }
}
