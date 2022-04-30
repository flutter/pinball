import 'package:pinball/game/game.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' as components;
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

/// Add methods to help loading and caching game assets.
extension PinballGameAssetsX on PinballGame {
  /// Returns a list of assets to be loaded
  List<Future> preLoadAssets() {
    const dashTheme = DashTheme();
    const sparkyTheme = SparkyTheme();
    const androidTheme = AndroidTheme();
    const dinoTheme = DinoTheme();

    return [
      images.load(components.Assets.images.ball.ball.keyName),
      images.load(components.Assets.images.ball.flameEffect.keyName),
      images.load(components.Assets.images.signpost.inactive.keyName),
      images.load(components.Assets.images.signpost.active1.keyName),
      images.load(components.Assets.images.signpost.active2.keyName),
      images.load(components.Assets.images.signpost.active3.keyName),
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
      images.load(components.Assets.images.dino.bottomWall.keyName),
      images.load(components.Assets.images.dino.topWall.keyName),
      images.load(components.Assets.images.dino.animatronic.head.keyName),
      images.load(components.Assets.images.dino.animatronic.mouth.keyName),
      images.load(components.Assets.images.dash.animatronic.keyName),
      images.load(components.Assets.images.dash.bumper.a.active.keyName),
      images.load(components.Assets.images.dash.bumper.a.inactive.keyName),
      images.load(components.Assets.images.dash.bumper.b.active.keyName),
      images.load(components.Assets.images.dash.bumper.b.inactive.keyName),
      images.load(components.Assets.images.dash.bumper.main.active.keyName),
      images.load(components.Assets.images.dash.bumper.main.inactive.keyName),
      images.load(components.Assets.images.plunger.plunger.keyName),
      images.load(components.Assets.images.plunger.rocket.keyName),
      images.load(components.Assets.images.boundary.bottom.keyName),
      images.load(components.Assets.images.boundary.outer.keyName),
      images.load(components.Assets.images.boundary.outerBottom.keyName),
      images.load(components.Assets.images.spaceship.saucer.keyName),
      images.load(components.Assets.images.spaceship.bridge.keyName),
      images.load(components.Assets.images.spaceship.ramp.boardOpening.keyName),
      images.load(
        components.Assets.images.spaceship.ramp.railingForeground.keyName,
      ),
      images.load(
        components.Assets.images.spaceship.ramp.railingBackground.keyName,
      ),
      images.load(components.Assets.images.spaceship.ramp.main.keyName),
      images
          .load(components.Assets.images.spaceship.ramp.arrow.inactive.keyName),
      images.load(
        components.Assets.images.spaceship.ramp.arrow.active1.keyName,
      ),
      images.load(
        components.Assets.images.spaceship.ramp.arrow.active2.keyName,
      ),
      images.load(
        components.Assets.images.spaceship.ramp.arrow.active3.keyName,
      ),
      images.load(
        components.Assets.images.spaceship.ramp.arrow.active4.keyName,
      ),
      images.load(
        components.Assets.images.spaceship.ramp.arrow.active5.keyName,
      ),
      images.load(components.Assets.images.spaceship.rail.main.keyName),
      images.load(components.Assets.images.spaceship.rail.exit.keyName),
      images.load(components.Assets.images.androidBumper.a.lit.keyName),
      images.load(components.Assets.images.androidBumper.a.dimmed.keyName),
      images.load(components.Assets.images.androidBumper.b.lit.keyName),
      images.load(components.Assets.images.androidBumper.b.dimmed.keyName),
      images.load(components.Assets.images.androidBumper.cow.lit.keyName),
      images.load(components.Assets.images.androidBumper.cow.dimmed.keyName),
      images.load(components.Assets.images.sparky.computer.top.keyName),
      images.load(components.Assets.images.sparky.computer.base.keyName),
      images.load(components.Assets.images.sparky.animatronic.keyName),
      images.load(components.Assets.images.sparky.bumper.a.inactive.keyName),
      images.load(components.Assets.images.sparky.bumper.a.active.keyName),
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
      images.load(dashTheme.leaderboardIcon.keyName),
      images.load(sparkyTheme.leaderboardIcon.keyName),
      images.load(androidTheme.leaderboardIcon.keyName),
      images.load(dinoTheme.leaderboardIcon.keyName),
      images.load(Assets.images.components.background.path),
    ];
  }
}
