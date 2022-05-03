import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SlingshotsGame extends BallGame {
  SlingshotsGame()
      : super(
          imagesFileNames: [
            Assets.images.slingshot.upper.keyName,
            Assets.images.slingshot.lower.keyName,
          ],
        );

  static const description = '''
    Shows how Slingshots are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(Slingshots());
    await ready();
    await traceAllBodies();
  }
}
