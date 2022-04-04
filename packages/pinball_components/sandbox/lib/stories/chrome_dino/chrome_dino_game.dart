import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

class ChromeDinoGame extends Forge2DGame {
  static const info = '''
  Shows how a ChromeDino is rendered.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    await add(
      ChromeDino()..initialPosition = center,
    );
  }
}
