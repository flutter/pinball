import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class ChromeDinoGame extends BasicGame {
  static const info = 'Shows how a ChromeDino is rendered.';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(ChromeDino());
  }
}
