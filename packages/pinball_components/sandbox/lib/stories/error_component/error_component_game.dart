import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class ErrorComponentGame extends AssetsGame {
  ErrorComponentGame({required this.text});

  static const description = 'Shows how ErrorComponents are rendered.';

  final String text;

  @override
  Future<void> onLoad() async {
    camera.followVector2(Vector2.zero());

    await add(ErrorComponent(label: text));
    await add(
      ErrorComponent.bold(
        label: text,
        position: Vector2(0, 10),
      ),
    );
  }
}
