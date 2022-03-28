import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' as components;

/// Add methods to help loading and caching game assets.
extension PinballGameAssetsX on PinballGame {
  /// Pre load the initial assets of the game.
  Future<void> preLoadAssets() async {
    await Future.wait([
      images.load(components.Assets.images.ball.keyName),
      images.load(Assets.images.components.flipper.path),
      images.load(Assets.images.components.background.path),
      images.load(Assets.images.components.spaceship.androidTop.path),
      images.load(Assets.images.components.spaceship.androidBottom.path),
      images.load(Assets.images.components.spaceship.lower.path),
      images.load(Assets.images.components.spaceship.upper.path),
    ]);
  }
}
