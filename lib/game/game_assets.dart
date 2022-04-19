import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' as components;

/// Add methods to help loading and caching game assets.
extension PinballGameAssetsX on PinballGame {
  /// Returns a list of assets to be loaded
  List<Future> preLoadAssets() {
    return [
      images.load(components.Assets.images.ball.ball.keyName),
      images.load(components.Assets.images.ball.flameEffect.keyName),
      images.load(components.Assets.images.flutterSignPost.keyName),
      images.load(components.Assets.images.flipper.left.keyName),
      images.load(components.Assets.images.flipper.right.keyName),
      images.load(components.Assets.images.baseboard.left.keyName),
      images.load(components.Assets.images.baseboard.right.keyName),
      images.load(components.Assets.images.kicker.left.keyName),
      images.load(components.Assets.images.kicker.right.keyName),
      images.load(components.Assets.images.slingshot.upper.keyName),
      images.load(components.Assets.images.slingshot.lower.keyName),
      images.load(components.Assets.images.launchRamp.ramp.keyName),
      images.load(
        components.Assets.images.launchRamp.foregroundRailing.keyName,
      ),
      images.load(
        components.Assets.images.launchRamp.backgroundRailing.keyName,
      ),
      images.load(components.Assets.images.dino.dinoLandTop.keyName),
      images.load(components.Assets.images.dino.dinoLandBottom.keyName),
      images.load(components.Assets.images.dash.animatronic.keyName),
      images.load(components.Assets.images.dash.bumper.a.active.keyName),
      images.load(components.Assets.images.dash.bumper.a.inactive.keyName),
      images.load(components.Assets.images.dash.bumper.b.active.keyName),
      images.load(components.Assets.images.dash.bumper.b.inactive.keyName),
      images.load(components.Assets.images.dash.bumper.main.active.keyName),
      images.load(components.Assets.images.dash.bumper.main.inactive.keyName),
      images.load(components.Assets.images.boundary.bottom.keyName),
      images.load(components.Assets.images.boundary.outer.keyName),
      images.load(components.Assets.images.spaceship.saucer.keyName),
      images.load(components.Assets.images.spaceship.bridge.keyName),
      images.load(components.Assets.images.spaceship.ramp.main.keyName),
      images.load(components.Assets.images.spaceship.ramp.boardOpening.keyName),
      images.load(
        components.Assets.images.spaceship.ramp.railingBackground.keyName,
      ),
      images.load(
        components.Assets.images.spaceship.ramp.railingForeground.keyName,
      ),
      images.load(components.Assets.images.spaceship.rail.main.keyName),
      images.load(components.Assets.images.spaceship.rail.foreground.keyName),
      images.load(components.Assets.images.chromeDino.mouth.keyName),
      images.load(components.Assets.images.chromeDino.head.keyName),
      images.load(components.Assets.images.plunger.plunger.keyName),
      images.load(components.Assets.images.plunger.rocket.keyName),
      images.load(components.Assets.images.sparky.computer.base.keyName),
      images.load(components.Assets.images.sparky.computer.top.keyName),
      images.load(components.Assets.images.sparky.bumper.a.active.keyName),
      images.load(components.Assets.images.sparky.bumper.a.inactive.keyName),
      images.load(components.Assets.images.sparky.bumper.b.active.keyName),
      images.load(components.Assets.images.sparky.bumper.b.inactive.keyName),
      images.load(components.Assets.images.sparky.bumper.c.active.keyName),
      images.load(components.Assets.images.sparky.bumper.c.inactive.keyName),
      images.load(components.Assets.images.backboard.backboardScores.keyName),
      images.load(components.Assets.images.backboard.backboardGameOver.keyName),
      images.load(components.Assets.images.googleWord.letter1.keyName),
      images.load(components.Assets.images.googleWord.letter2.keyName),
      images.load(components.Assets.images.googleWord.letter3.keyName),
      images.load(components.Assets.images.googleWord.letter4.keyName),
      images.load(components.Assets.images.googleWord.letter5.keyName),
      images.load(components.Assets.images.googleWord.letter6.keyName),
      images.load(components.Assets.images.backboard.display.keyName),
      images.load(Assets.images.components.background.path),
    ];
  }
}
