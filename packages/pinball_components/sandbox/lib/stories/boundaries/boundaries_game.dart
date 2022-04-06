import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class BoundariesGame extends BasicBallGame {
  BoundariesGame({
    required this.trace,
  }) : super(color: const Color(0xFFFF0000));

  static const info = '''
    Shows how Boundaries are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  final bool trace;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await addFromBlueprint(Boundaries());
    await ready();

    camera
      ..followVector2(Vector2.zero())
      ..zoom = 6;

    final bottomBoundary = children.whereType<BodyComponent>().first;
    final outerBoundary = children.whereType<BodyComponent>().last;

    if (trace) {
      bottomBoundary.trace();
      outerBoundary.trace();
    }
  }
}
