import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BackboardGameOverGame extends BasicGame {
  static const info = '''
      Simple example showing the waiting mode of the backboard.
  ''';

  @override
  Future<void> onLoad() async {
    camera
      ..followVector2(Vector2.zero())
      ..zoom = 5;

    await add(
      Backboard(
        position: Vector2(0, 20),
        startsAtWaiting: false,
      ),
    );
  }
}
