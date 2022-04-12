import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BackboardGameOverGame extends BasicKeyboardGame {
  BackboardGameOverGame(this.score);

  static const info = '''
      Simple example showing the waiting mode of the backboard.
  ''';

  final int score;

  @override
  Future<void> onLoad() async {
    camera
      ..followVector2(Vector2.zero())
      ..zoom = 5;

    await add(
      Backboard.gameOver(
        position: Vector2(0, 20),
        score: score,
      ),
    );
  }
}
