import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class BoundariesGame extends BasicBallGame with Traceable {
  static const info = '''
    Shows how Boundaries are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.boundary.outer.keyName,
      Assets.images.boundary.bottom.keyName,
    ]);

    await addFromBlueprint(Boundaries());
    await ready();

    camera
      ..followVector2(Vector2.zero())
      ..zoom = 6;

    await traceAllBodies();
  }
}
