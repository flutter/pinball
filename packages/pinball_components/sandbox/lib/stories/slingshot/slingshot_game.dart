import 'package:flame/extensions.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SlingshotGame extends BasicBallGame with Traceable {
  SlingshotGame({
    required bool trace,
  })  : _trace = trace,
        super(color: const Color(0xFFFF0000));

  static const info = '''
    Shows how Slingshots are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  final bool _trace;

  @override
  bool get trace => _trace;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addFromBlueprint(Slingshots());
    camera.followVector2(Vector2.zero());
    await traceAllBodies();
  }
}
