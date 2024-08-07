import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/games.dart';

class ArrowIconGame extends AssetsGame with TapCallbacks {
  ArrowIconGame()
      : super(
          imagesFileNames: [
            Assets.images.displayArrows.arrowLeft.keyName,
            Assets.images.displayArrows.arrowRight.keyName,
          ],
        );

  static const description = 'Shows how ArrowIcons are rendered.';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.follow(PositionComponent(position: Vector2.zero()));

    await add(
      ArrowIcon(
        position: Vector2.zero(),
        direction: ArrowIconDirection.left,
        onTap: () {},
      ),
    );

    await add(
      ArrowIcon(
        position: Vector2(0, 20),
        direction: ArrowIconDirection.right,
        onTap: () {},
      ),
    );
  }
}
