import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' as components;

/// Add methods to help loading and caching game assets.
extension PinballGameAssetsX on PinballGame {
  /// Pre load the initial assets of the game.
  Future<void> preLoadAssets() async {
    await Future.wait([
      images.load(components.Assets.images.ball.keyName),
      images.load(components.Assets.images.flutterSignPost.keyName),
      images.load(components.Assets.images.flipper.left.keyName),
      images.load(components.Assets.images.flipper.right.keyName),
      images.load(components.Assets.images.baseboard.left.keyName),
      images.load(components.Assets.images.baseboard.right.keyName),
      images.load(components.Assets.images.dino.dinoLandTop.keyName),
      images.load(components.Assets.images.dino.dinoLandBottom.keyName),
      images.load(components.Assets.images.dashBumper.a.active.keyName),
      images.load(components.Assets.images.dashBumper.a.inactive.keyName),
      images.load(components.Assets.images.dashBumper.b.active.keyName),
      images.load(components.Assets.images.dashBumper.b.inactive.keyName),
      images.load(components.Assets.images.dashBumper.main.active.keyName),
      images.load(components.Assets.images.dashBumper.main.inactive.keyName),
      images.load(components.Assets.images.spaceshipRamp.spaceshipRamp.keyName),
      images.load(
        components.Assets.images.spaceshipRamp.spaceshipRailingBg.keyName,
      ),
      images.load(
        components.Assets.images.spaceshipRamp.spaceshipRailingFg.keyName,
      ),
      images.load(Assets.images.components.background.path),
      images.load(Assets.images.components.spaceshipDropTube.path),
    ]);
  }
}
