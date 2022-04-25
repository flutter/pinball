// ignore_for_file: public_member_api_docs

import 'package:pinball_components/pinball_components.dart';

/// {@template render_priority}
/// Priorities for the component rendering order in the pinball game.
/// {@endtemplate}
// TODO(allisonryan0002): find alternative to section comments.
abstract class RenderPriority {
  static const _base = 0;
  static const _above = 1;
  static const _below = -1;

  // Ball

  /// Render priority for the [Ball] while it's on the board.
  static const int ballOnBoard = _base;

  /// Render priority for the [Ball] while it's on the [SpaceshipRamp].
  static const int ballOnSpaceshipRamp =
      _above + spaceshipRampBackgroundRailing;

  /// Render priority for the [Ball] while it's on the [Spaceship].
  static const int ballOnSpaceship = _above + spaceshipSaucer;

  /// Render priority for the [Ball] while it's on the [SpaceshipRail].
  static const int ballOnSpaceshipRail = _below + spaceshipSaucer;

  /// Render priority for the [Ball] while it's on the [LaunchRamp].
  static const int ballOnLaunchRamp = _above + launchRamp;

  // Background

  // TODO(allisonryan0002): fix this magic priority. Could bump all priorities
  // so there are no negatives.
  static const int background = 3 * _below + _base;

  // Boundaries

  static const int bottomBoundary = _above + dinoBottomWall;

  static const int outerBoundary = _above + background;

  static const int outerBottomBoundary = _above + rocket;

  // Bottom Group

  static const int bottomGroup = _above + ballOnBoard;

  // Launcher

  static const int launchRamp = _above + outerBoundary;

  static const int launchRampForegroundRailing = _below + ballOnBoard;

  static const int plunger = _above + launchRamp;

  static const int rocket = _above + bottomBoundary;

  // Dino Land

  static const int dinoTopWall = _above + ballOnBoard;

  static const int dino = _above + dinoTopWall;

  static const int dinoBottomWall = _above + dino;

  static const int slingshot = _above + dinoBottomWall;

  // Flutter Forest

  static const int signpost = _above + launchRampForegroundRailing;

  static const int dashBumper = _above + ballOnBoard;

  static const int dashAnimatronic = 2 * _above + launchRamp;

  // Sparky Fire Zone

  static const int computerBase = _below + ballOnBoard;

  static const int computerTop = _above + ballOnBoard;

  static const int sparkyAnimatronic = _above + spaceshipRampForegroundRailing;

  static const int sparkyBumper = _above + ballOnBoard;

  static const int turboChargeFlame = _above + ballOnBoard;

  // Android Spaceship

  static const int spaceshipRail = _above + bottomGroup;

  static const int spaceshipRailForeground = _above + spaceshipRail;

  static const int spaceshipSaucer = _above + spaceshipRail;

  static const int spaceshipSaucerWall = _above + spaceshipSaucer;

  static const int androidHead = _above + spaceshipSaucer;

  static const int spaceshipRamp = _above + ballOnBoard;

  static const int spaceshipRampBackgroundRailing = _above + spaceshipRamp;

  static const int spaceshipRampArrow = _above + spaceshipRamp;

  static const int spaceshipRampForegroundRailing =
      _above + ballOnSpaceshipRamp;

  static const int spaceshipRampBoardOpening = _below + ballOnBoard;

  static const int alienBumper = _above + ballOnBoard;

  // Score Text

  static const int scoreText = _above + spaceshipRampForegroundRailing;

  // Debug information
  static const int debugInfo = _above + scoreText;
}
