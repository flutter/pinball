import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;
import 'package:sandbox/common/common.dart';

class BallBoosterGame extends LineGame {
  BallBoosterGame()
      : super(
          imagesFileNames: [
            Assets.images.ball.ball.keyName,
            theme.Assets.images.android.ball.keyName,
            theme.Assets.images.dash.ball.keyName,
            theme.Assets.images.dino.ball.keyName,
            theme.Assets.images.sparky.ball.keyName,
            Assets.images.ball.flameEffect.keyName,
          ],
        );

  static const description = '''
    Shows how a Ball with a boost works.

    - Drag to launch a boosted Ball.
''';

  @override
  void onLine(Vector2 line) {
    final ball = Ball();
    add(ball);

    ball.mounted.then((value) => ball.boost(line * -1 * 20));
  }
}
