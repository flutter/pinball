import 'dart:async';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class BigDashNestBumperGame extends BallGame with Traceable {
  static const description = '''
    Shows how a BigDashNestBumper is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.dash.bumper.main.active.keyName,
      Assets.images.dash.bumper.main.inactive.keyName,
    ]);

    camera.followVector2(Vector2.zero());
    await add(DashNestBumper.main()..priority = 1);
    await traceAllBodies();
  }
}
