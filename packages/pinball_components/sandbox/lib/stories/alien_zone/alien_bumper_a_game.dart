import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class AlienBumperAGame extends BallGame {
  AlienBumperAGame()
      : super(
          color: const Color(0xFF0000FF),
          imagesFileNames: [
            Assets.images.alienBumper.a.active.keyName,
            Assets.images.alienBumper.a.inactive.keyName,
          ],
        );

  static const description = '''
    Shows how a AlienBumperA is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(
      AlienBumper.a()..priority = 1,
    );

    await traceAllBodies();
  }
}
