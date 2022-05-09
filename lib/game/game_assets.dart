import 'package:flame/extensions.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart' as components;
import 'package:pinball_theme/pinball_theme.dart' hide Assets;

/// Add methods to help loading and caching game assets.
extension PinballGameAssetsX on PinballGame {
  /// Returns a list of assets to be loaded
  List<Future<Image> Function()> preLoadAssets() {
    const dashTheme = DashTheme();
    const sparkyTheme = SparkyTheme();
    const androidTheme = AndroidTheme();
    const dinoTheme = DinoTheme();
    return [
      () => images.load(components.Assets.images.boardBackground.keyName),
      () => images.load(components.Assets.images.ball.flameEffect.keyName),
      () => images.load(components.Assets.images.signpost.inactive.keyName),
      () => images.load(components.Assets.images.signpost.active1.keyName),
      () => images.load(components.Assets.images.signpost.active2.keyName),
      () => images.load(components.Assets.images.signpost.active3.keyName),
      () => images.load(components.Assets.images.flipper.left.keyName),
      () => images.load(components.Assets.images.flipper.right.keyName),
      () => images.load(components.Assets.images.baseboard.left.keyName),
      () => images.load(components.Assets.images.baseboard.right.keyName),
      () => images.load(components.Assets.images.kicker.left.lit.keyName),
      () => images.load(components.Assets.images.kicker.left.dimmed.keyName),
      () => images.load(components.Assets.images.kicker.right.lit.keyName),
      () => images.load(components.Assets.images.kicker.right.dimmed.keyName),
      () => images.load(components.Assets.images.slingshot.upper.keyName),
      () => images.load(components.Assets.images.slingshot.lower.keyName),
      () => images.load(components.Assets.images.launchRamp.ramp.keyName),
      () => images.load(
            components.Assets.images.launchRamp.foregroundRailing.keyName,
          ),
      () => images.load(
            components.Assets.images.launchRamp.backgroundRailing.keyName,
          ),
      () => images.load(components.Assets.images.dino.bottomWall.keyName),
      () => images.load(components.Assets.images.dino.topWall.keyName),
      () => images.load(components.Assets.images.dino.topWallTunnel.keyName),
      () => images.load(components.Assets.images.dino.animatronic.head.keyName),
      () =>
          images.load(components.Assets.images.dino.animatronic.mouth.keyName),
      () => images.load(components.Assets.images.dash.animatronic.keyName),
      () => images.load(components.Assets.images.dash.bumper.a.active.keyName),
      () =>
          images.load(components.Assets.images.dash.bumper.a.inactive.keyName),
      () => images.load(components.Assets.images.dash.bumper.b.active.keyName),
      () =>
          images.load(components.Assets.images.dash.bumper.b.inactive.keyName),
      () =>
          images.load(components.Assets.images.dash.bumper.main.active.keyName),
      () => images
          .load(components.Assets.images.dash.bumper.main.inactive.keyName),
      () => images.load(components.Assets.images.plunger.plunger.keyName),
      () => images.load(components.Assets.images.plunger.rocket.keyName),
      () => images.load(components.Assets.images.boundary.bottom.keyName),
      () => images.load(components.Assets.images.boundary.outer.keyName),
      () => images.load(components.Assets.images.boundary.outerBottom.keyName),
      () => images
          .load(components.Assets.images.android.spaceship.saucer.keyName),
      () => images
          .load(components.Assets.images.android.spaceship.animatronic.keyName),
      () => images
          .load(components.Assets.images.android.spaceship.lightBeam.keyName),
      () => images
          .load(components.Assets.images.android.ramp.boardOpening.keyName),
      () => images.load(
            components.Assets.images.android.ramp.railingForeground.keyName,
          ),
      () => images.load(
            components.Assets.images.android.ramp.railingBackground.keyName,
          ),
      () => images.load(components.Assets.images.android.ramp.main.keyName),
      () => images
          .load(components.Assets.images.android.ramp.arrow.inactive.keyName),
      () => images.load(
            components.Assets.images.android.ramp.arrow.active1.keyName,
          ),
      () => images.load(
            components.Assets.images.android.ramp.arrow.active2.keyName,
          ),
      () => images.load(
            components.Assets.images.android.ramp.arrow.active3.keyName,
          ),
      () => images.load(
            components.Assets.images.android.ramp.arrow.active4.keyName,
          ),
      () => images.load(
            components.Assets.images.android.ramp.arrow.active5.keyName,
          ),
      () => images.load(components.Assets.images.android.rail.main.keyName),
      () => images.load(components.Assets.images.android.rail.exit.keyName),
      () => images.load(components.Assets.images.android.bumper.a.lit.keyName),
      () =>
          images.load(components.Assets.images.android.bumper.a.dimmed.keyName),
      () => images.load(components.Assets.images.android.bumper.b.lit.keyName),
      () =>
          images.load(components.Assets.images.android.bumper.b.dimmed.keyName),
      () =>
          images.load(components.Assets.images.android.bumper.cow.lit.keyName),
      () => images
          .load(components.Assets.images.android.bumper.cow.dimmed.keyName),
      () => images.load(components.Assets.images.sparky.computer.top.keyName),
      () => images.load(components.Assets.images.sparky.computer.base.keyName),
      () => images.load(components.Assets.images.sparky.computer.glow.keyName),
      () => images.load(components.Assets.images.sparky.animatronic.keyName),
      () => images.load(components.Assets.images.sparky.bumper.a.lit.keyName),
      () =>
          images.load(components.Assets.images.sparky.bumper.a.dimmed.keyName),
      () => images.load(components.Assets.images.sparky.bumper.b.lit.keyName),
      () =>
          images.load(components.Assets.images.sparky.bumper.b.dimmed.keyName),
      () => images.load(components.Assets.images.sparky.bumper.c.lit.keyName),
      () =>
          images.load(components.Assets.images.sparky.bumper.c.dimmed.keyName),
      () => images.load(components.Assets.images.backbox.marquee.keyName),
      () =>
          images.load(components.Assets.images.backbox.displayDivider.keyName),
      () =>
          images.load(components.Assets.images.backbox.button.facebook.keyName),
      () =>
          images.load(components.Assets.images.backbox.button.twitter.keyName),
      () => images.load(
            components.Assets.images.backbox.displayTitleDecoration.keyName,
          ),
      () =>
          images.load(components.Assets.images.googleWord.letter1.lit.keyName),
      () => images
          .load(components.Assets.images.googleWord.letter1.dimmed.keyName),
      () =>
          images.load(components.Assets.images.googleWord.letter2.lit.keyName),
      () => images
          .load(components.Assets.images.googleWord.letter2.dimmed.keyName),
      () =>
          images.load(components.Assets.images.googleWord.letter3.lit.keyName),
      () => images
          .load(components.Assets.images.googleWord.letter3.dimmed.keyName),
      () =>
          images.load(components.Assets.images.googleWord.letter4.lit.keyName),
      () => images
          .load(components.Assets.images.googleWord.letter4.dimmed.keyName),
      () =>
          images.load(components.Assets.images.googleWord.letter5.lit.keyName),
      () => images
          .load(components.Assets.images.googleWord.letter5.dimmed.keyName),
      () =>
          images.load(components.Assets.images.googleWord.letter6.lit.keyName),
      () => images
          .load(components.Assets.images.googleWord.letter6.dimmed.keyName),
      () => images
          .load(components.Assets.images.googleRollover.left.decal.keyName),
      () =>
          images.load(components.Assets.images.googleRollover.left.pin.keyName),
      () => images
          .load(components.Assets.images.googleRollover.right.decal.keyName),
      () => images
          .load(components.Assets.images.googleRollover.right.pin.keyName),
      () => images.load(components.Assets.images.multiball.lit.keyName),
      () => images.load(components.Assets.images.multiball.dimmed.keyName),
      () => images.load(components.Assets.images.multiplier.x2.lit.keyName),
      () => images.load(components.Assets.images.multiplier.x2.dimmed.keyName),
      () => images.load(components.Assets.images.multiplier.x3.lit.keyName),
      () => images.load(components.Assets.images.multiplier.x3.dimmed.keyName),
      () => images.load(components.Assets.images.multiplier.x4.lit.keyName),
      () => images.load(components.Assets.images.multiplier.x4.dimmed.keyName),
      () => images.load(components.Assets.images.multiplier.x5.lit.keyName),
      () => images.load(components.Assets.images.multiplier.x5.dimmed.keyName),
      () => images.load(components.Assets.images.multiplier.x6.lit.keyName),
      () => images.load(components.Assets.images.multiplier.x6.dimmed.keyName),
      () => images.load(components.Assets.images.score.fiveThousand.keyName),
      () => images.load(components.Assets.images.score.twentyThousand.keyName),
      () => images
          .load(components.Assets.images.score.twoHundredThousand.keyName),
      () => images.load(components.Assets.images.score.oneMillion.keyName),
      () => images.load(components.Assets.images.flapper.backSupport.keyName),
      () => images.load(components.Assets.images.flapper.frontSupport.keyName),
      () => images.load(components.Assets.images.flapper.flap.keyName),
      () => images.load(components.Assets.images.skillShot.decal.keyName),
      () => images.load(components.Assets.images.skillShot.pin.keyName),
      () => images.load(components.Assets.images.skillShot.lit.keyName),
      () => images.load(components.Assets.images.skillShot.dimmed.keyName),
      () =>
          images.load(components.Assets.images.displayArrows.arrowLeft.keyName),
      () => images
          .load(components.Assets.images.displayArrows.arrowRight.keyName),
      () => images.load(androidTheme.leaderboardIcon.keyName),
      () => images.load(androidTheme.ball.keyName),
      () => images.load(dashTheme.leaderboardIcon.keyName),
      () => images.load(dashTheme.ball.keyName),
      () => images.load(dinoTheme.leaderboardIcon.keyName),
      () => images.load(dinoTheme.ball.keyName),
      () => images.load(sparkyTheme.leaderboardIcon.keyName),
      () => images.load(sparkyTheme.ball.keyName),
      () => images.load(androidTheme.background.keyName),
      () => images.load(dashTheme.background.keyName),
      () => images.load(dinoTheme.background.keyName),
      () => images.load(sparkyTheme.background.keyName),
    ];
  }
}
