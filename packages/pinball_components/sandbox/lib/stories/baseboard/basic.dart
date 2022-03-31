import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BasicBaseboardGame extends BasicGame {
  static const info = '''
      Basic example of how a Baseboard works.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);

    final leftBaseboard = Baseboard(side: BoardSide.left)
      ..initialPosition = center - Vector2(25, 0);
    final rightBaseboard = Baseboard(side: BoardSide.right)
      ..initialPosition = center + Vector2(25, 0);

    await addAll([
      leftBaseboard,
      rightBaseboard,
    ]);
  }
}
