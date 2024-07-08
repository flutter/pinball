import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class BoundariesGame extends BallGame {
  BoundariesGame()
      : super(
          imagesFileNames: [
            Assets.images.boundary.outer.keyName,
            Assets.images.boundary.outerBottom.keyName,
            Assets.images.boundary.bottom.keyName,
          ],
        );

  static const description = '''
    Shows how Boundaries are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera
      ..follow(PositionComponent(position: Vector2.zero()))
      ..viewfinder.zoom = 6;
    await add(Boundaries());
    await ready();
    await traceAllBodies();
  }
}
