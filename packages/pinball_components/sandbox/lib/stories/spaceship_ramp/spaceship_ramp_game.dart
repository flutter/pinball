import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SpaceshipRampGame extends BasicBallGame with Traceable {
  SpaceshipRampGame() : super(color: const Color(0xFFFF0000));

  static const info = '''
    Shows how SpaceshipRamp is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addFromBlueprint(SpaceshipRamp());
    camera.followVector2(Vector2(-12, -50));
    await traceAllBodies();
  }
}
