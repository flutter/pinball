import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SlingshotGame extends BasicBallGame with Traceable {
  static const info = '''
    Shows how Slingshots are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await images.loadAll([
      Assets.images.slingshot.upper.keyName,
      Assets.images.slingshot.lower.keyName,
    ]);

    await addFromBlueprint(Slingshots());
    camera.followVector2(Vector2.zero());
    await traceAllBodies();
  }
}
