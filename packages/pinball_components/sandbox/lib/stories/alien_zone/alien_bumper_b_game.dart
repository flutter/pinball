import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class AlienBumperBGame extends BallGame {
  AlienBumperBGame()
      : super(
          color: const Color(0xFF0000FF),
          imagesFileNames: [
            Assets.images.alienBumper.b.active.keyName,
            Assets.images.alienBumper.b.inactive.keyName,
          ],
        );

  static const description = '''
    Shows how a AlienBumperB is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(
      AlienBumper.b()..priority = 1,
    );

    await traceAllBodies();
  }
}
