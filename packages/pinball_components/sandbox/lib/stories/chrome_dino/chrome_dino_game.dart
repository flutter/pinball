import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

class ChromeDinoGame extends Forge2DGame {
  static const description = 'Shows how a ChromeDino is rendered.';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(ChromeDino());
  }
}
