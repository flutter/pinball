import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class KickerGame extends BallGame {
  KickerGame()
      : super(
          imagesFileNames: [
            Assets.images.kicker.left.lit.keyName,
            Assets.images.kicker.left.dimmed.keyName,
            Assets.images.kicker.right.lit.keyName,
            Assets.images.kicker.right.dimmed.keyName,
          ],
        );

  static const description = '''
    Shows how Kickers are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    await addAll(
      [
        Kicker(side: BoardSide.left)
          ..initialPosition = Vector2(center.x - 8.8, center.y),
        Kicker(side: BoardSide.right)
          ..initialPosition = Vector2(center.x + 8.8, center.y),
      ],
    );

    await traceAllBodies();
  }
}
