import 'package:flame_forge2d/flame_forge2d.dart';

String buildSourceLink(String path) {
  return 'https://github.com/VGVentures/pinball/tree/main/packages/pinball_components/sandbox/lib/stories/$path';
}

class BasicGame extends Forge2DGame {
  BasicGame() {
    images.prefix = '';
  }
}
