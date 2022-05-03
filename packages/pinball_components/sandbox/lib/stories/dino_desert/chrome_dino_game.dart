import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class ChromeDinoGame extends BallGame {
  ChromeDinoGame()
      : super(
          imagesFileNames: [
            Assets.images.dino.animatronic.mouth.keyName,
            Assets.images.dino.animatronic.head.keyName,
          ],
        );

  static const description = '''
    Shows how ChromeDino is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(ChromeDino());

    await traceAllBodies();
  }
}
