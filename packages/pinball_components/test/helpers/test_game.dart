import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class TestGame extends Forge2DGame {
  TestGame() {
    images.prefix = '';
  }
}

class KeyboardTestGame extends TestGame with HasKeyboardHandlerComponents {}
