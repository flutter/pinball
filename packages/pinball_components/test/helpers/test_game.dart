import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class TestGame extends Forge2DGame {
  TestGame([List<String>? assets]) : _assets = assets {
    images.prefix = '';
  }

  final List<String>? _assets;

  @override
  Future<void> onLoad() async {
    if (_assets != null) {
      await images.loadAll(_assets!);
    }
    await super.onLoad();
  }
}

class KeyboardTestGame extends TestGame with HasKeyboardHandlerComponents {}
