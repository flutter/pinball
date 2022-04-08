import 'dart:async';
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SmallDashNestBumperAGame extends BasicBallGame with Traceable {
  SmallDashNestBumperAGame() : super(color: const Color(0xFF0000FF));

  static const info = '''
    Shows how a SmallDashNestBumper ("a") is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.followVector2(Vector2.zero());
    await add(SmallDashNestBumper.a()..priority = 1);
    await traceAllBodies();
    await traceAllBodies();
  }
}
