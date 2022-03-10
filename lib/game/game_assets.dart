import 'package:pinball/game/game.dart';

/// Add methods to help loading and caching game assets.
extension PinballGameAssetsX on PinballGame {
  /// Pre load the initial assets of the game.
  Future<void> preLoadAssets() async {
    await Future.wait([
      images.load(Ball.spritePath),
      images.load(Flipper.spritePath),
    ]);
  }
}
