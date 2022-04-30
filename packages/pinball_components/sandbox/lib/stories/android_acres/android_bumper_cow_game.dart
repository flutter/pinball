import 'dart:async';

import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class AndroidBumperCowGame extends BallGame {
  AndroidBumperCowGame()
      : super(
          imagesFileNames: [
            Assets.images.androidBumper.cow.lit.keyName,
            Assets.images.androidBumper.cow.dimmed.keyName,
          ],
        );

  static const description = '''
    Shows how a AndroidBumper.cow is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(
      AndroidBumper.cow()..priority = 1,
    );

    await traceAllBodies();
  }
}
