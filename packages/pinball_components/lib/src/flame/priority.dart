// ignore_for_file: public_member_api_docs

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template render_priority}
/// Priorities for the component rendering order in the pinball game.
/// {@endtemplate}
abstract class RenderPriority {
  static const _base = 0;
  static const _above = 1;
  static const _below = -1;

  // BALL

  /// Render priority for the [Ball] while it's on the board.
  static const int ballOnBoard = _base;

  /// Render priority for the [Ball] while it's on the [SpaceshipRamp].
  static const int ballOnSpaceshipRamp =
      _above + spaceshipRampBackgroundRailing;

  /// Render priority for the [Ball] while it's on the [Spaceship].
  static const int ballOnSpaceship = _above + spaceshipSaucer;

  /// Render priority for the [Ball] while it's on the [SpaceshipRail].
  static const int ballOnSpaceshipRail = spaceshipRail;

  /// Render priority for the [Ball] while it's on the [LaunchRamp].
  static const int ballOnLaunchRamp = _above + launchRamp;

  // BACKGROUND

  static const int background = 3 * _below + _base;

  // BOUNDARIES

  static const int bottomBoundary = _above + dinoBottomWall;

  static const int outerBoudary = _above + background;

  // BOTTOM GROUP

  static const int bottomGroup = _above + ballOnBoard;

  // LAUNCHER

  static const int launchRamp = _above + outerBoudary;

  static const int launchRampForegroundRailing = _above + ballOnLaunchRamp;

  static const int plunger = _above + launchRamp;

  static const int rocket = _above + bottomBoundary;

  // DINO LAND

  static const int dinoTopWall = _above + ballOnBoard;

  static const int dino = _above + dinoTopWall;

  static const int dinoBottomWall = _above + dino;

  static const int slingshot = _above + ballOnBoard;

  // FLUTTER FOREST

  static const int flutterSignPost = _above + launchRampForegroundRailing;

  static const int dashBumper = _above + ballOnBoard;

  static const int dashAnimatronic = _above + launchRampForegroundRailing;

  // SPARKY FIRE ZONE

  static const int computerBase = _below + ballOnBoard;

  static const int computerTop = _above + ballOnBoard;

  static const int sparkyAnimatronic = _above + spaceshipRampForegroundRailing;

  static const int sparkyBumper = _above + ballOnBoard;

  // ANDROID SPACESHIP

  static const int spaceshipRail = _above + bottomGroup;

  static const int spaceshipRailForeground = _above + spaceshipRail;

  static const int spaceshipSaucer = _above + spaceshipRail;

  static const int spaceshipSaucerWall = _above + spaceshipSaucer;

  static const int androidHead = _above + spaceshipSaucer;

  static const int spaceshipRamp = _above + ballOnBoard;

  static const int spaceshipRampBackgroundRailing = _above + spaceshipRamp;

  static const int spaceshipRampForegroundRailing =
      _above + ballOnSpaceshipRamp;

  static const int spaceshipRampBoardOpening = _below + ballOnBoard;

  static const int alienBumper = _above + ballOnBoard;

  // SCORE TEXT

  static const int scoreText = _above + spaceshipRampForegroundRailing;
}

/// Helper methods to change the [priority] of a [Component].
// TODO(allisonryan0002): we only use sendTo, can the other methods be removed?
extension ComponentPriorityX on Component {
  static const _lowestPriority = 0;

  /// Changes the priority to a specific one.
  void sendTo(int destinationPriority) {
    if (priority != destinationPriority) {
      priority = math.max(destinationPriority, _lowestPriority);
      reorderChildren();
    }
  }

  /// Changes the priority to the lowest possible.
  void sendToBack() {
    if (priority != _lowestPriority) {
      priority = _lowestPriority;
      reorderChildren();
    }
  }

  /// Decreases the priority to be lower than another [Component].
  void showBehindOf(Component other) {
    if (priority >= other.priority) {
      priority = math.max(other.priority - 1, _lowestPriority);
      reorderChildren();
    }
  }

  /// Increases the priority to be higher than another [Component].
  void showInFrontOf(Component other) {
    if (priority <= other.priority) {
      priority = other.priority + 1;
      reorderChildren();
    }
  }
}
