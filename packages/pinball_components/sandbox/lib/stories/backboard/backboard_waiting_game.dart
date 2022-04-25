import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class BackboardWaitingGame extends AssetsGame {
  BackboardWaitingGame()
      : super(
          imagesFileNames: [],
        );

  static const description = '''
      Shows how the Backboard in waiting mode is rendered.
  ''';

  @override
  Future<void> onLoad() async {
    camera
      ..followVector2(Vector2.zero())
      ..zoom = 5;

    await add(
      Backboard.waiting(position: Vector2(0, 20)),
    );
  }
}
