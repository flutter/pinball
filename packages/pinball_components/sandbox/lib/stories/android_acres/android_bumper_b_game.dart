import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class AndroidBumperBGame extends BallGame {
  AndroidBumperBGame()
      : super(
          color: const Color(0xFF0000FF),
          imagesFileNames: [
            Assets.images.android.bumper.b.lit.keyName,
            Assets.images.android.bumper.b.dimmed.keyName,
          ],
        );

  static const description = '''
    Shows how a AndroidBumperB is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(
      AndroidBumper.b()..priority = 1,
    );

    await traceAllBodies();
  }
}
