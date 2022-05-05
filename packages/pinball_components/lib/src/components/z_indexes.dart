// ignore_for_file: public_member_api_docs

/// Z-Indexes for the component rendering order in the pinball game.
// TODO(allisonryan0002): find alternative to section comments.
abstract class ZIndexes {
  static const _base = 0;
  static const _above = 1;
  static const _below = -1;

  // Ball

  static const ballOnBoard = _base;

  static const ballOnSpaceshipRamp = _above + spaceshipRampBackgroundRailing;

  static const ballOnSpaceship = _above + spaceshipSaucer;

  static const ballOnSpaceshipRail = _above + spaceshipRail;

  static const ballOnLaunchRamp = _above + launchRamp;

  // Background

  // TODO(allisonryan0002): fix this magic zindex. Could bump all priorities so
  // there are no negatives.
  static const boardBackground = 5 * _below + _base;

  static const decal = _above + boardBackground;

  // Boundaries

  static const bottomBoundary = _above + dinoBottomWall;

  static const outerBoundary = _above + boardBackground;

  static const outerBottomBoundary = _above + bottomBoundary;

  // Bottom Group

  static const bottomGroup = _above + ballOnBoard;

  // Launcher

  static const launchRamp = _above + outerBoundary;

  static const launchRampForegroundRailing = _above + ballOnLaunchRamp;

  static const flapperBack = _above + outerBoundary;

  static const flapperFront = _above + flapper;

  static const flapper = _above + ballOnLaunchRamp;

  static const plunger = _above + launchRamp;

  static const rocket = _below + bottomBoundary;

  // Dino Desert

  static const dinoTopWall = _above + ballOnBoard;

  static const dinoTopWallTunnel = _below + ballOnBoard;

  static const dino = _above + dinoTopWall;

  static const dinoBottomWall = _above + dino;

  static const slingshots = _above + dinoBottomWall;

  // Flutter Forest

  static const flutterForest = _above + ballOnBoard;

  // Sparky Scorch

  static const computerBase = _below + ballOnBoard;

  static const computerTop = _above + ballOnBoard;

  static const computerGlow = _above + ballOnBoard;

  static const sparkyAnimatronic = _above + spaceshipRampForegroundRailing;

  static const sparkyBumper = _above + ballOnBoard;

  static const turboChargeFlame = _above + ballOnBoard;

  // Android Acres

  static const spaceshipRail = _above + bottomGroup;

  static const spaceshipRailExit = _above + ballOnSpaceshipRail;

  static const spaceshipSaucer = _above + ballOnSpaceshipRail;

  static const spaceshipLightBeam = _below + spaceshipSaucer;

  static const androidHead = _above + ballOnSpaceship;

  static const spaceshipRamp = _above + sparkyBumper;

  static const spaceshipRampBackgroundRailing = _above + spaceshipRamp;

  static const spaceshipRampArrow = _above + spaceshipRamp;

  static const spaceshipRampForegroundRailing = _above + ballOnSpaceshipRamp;

  static const spaceshipRampBoardOpening = _below + ballOnBoard;

  static const androidBumper = _above + ballOnBoard;

  // Score

  static const score = _above + spaceshipRampForegroundRailing;

  // Debug information

  static const debugInfo = _above + score;

  // Backbox

  static const backbox = _below + outerBoundary;
}
