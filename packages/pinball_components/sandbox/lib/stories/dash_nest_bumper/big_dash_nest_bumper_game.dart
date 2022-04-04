import 'dart:async';
import 'dart:ui';

import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class BigDashNestBumperGame extends BasicBallGame {
  BigDashNestBumperGame({
    required this.trace,
  }) : super(color: const Color(0xFF0000FF));

  static const info = '''
    Shows how a BigDashNestBumper is rendered.

    Activate the "trace" parameter to overlay the body.
''';

  final bool trace;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    final bigDashNestBumper = BigDashNestBumper()
      ..initialPosition = center
      ..priority = 1;
    await add(bigDashNestBumper);

    if (trace) bigDashNestBumper.trace();
  }
}
