import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';

import 'package:sandbox/stories/ball/basic_ball_game.dart';

class FlipperGame extends BallGame with KeyboardEvents {
  FlipperGame()
      : super(
          imagesFileNames: [
            Assets.images.flipper.left.keyName,
            Assets.images.flipper.right.keyName,
          ],
        );

  static const description = '''
    Shows how Flippers are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
    - Press left arrow key or "A" to move the left flipper.
    - Press right arrow key or "D" to move the right flipper.
  ''';

  late Flipper leftFlipper;
  late Flipper rightFlipper;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    await addAll([
      leftFlipper = Flipper(side: BoardSide.left)
        ..initialPosition = center - Vector2(Flipper.size.x, 0),
      rightFlipper = Flipper(side: BoardSide.right)
        ..initialPosition = center + Vector2(Flipper.size.x, 0),
    ]);

    await traceAllBodies();
  }
}
