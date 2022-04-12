import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template pinball_priority}
/// Priorities for the component rendering order in the pinball game.
/// {@endtemplate}
abstract class PinballPriority {
  static const base = 0;
  static const above = 1;
  static const below = -1;

  // BALL

  /// Render priority for the [Ball] while it's on the board.
  static const int ballOnBoard = base;

  /// Render priority for the [Ball] while it's on the [SpaceshipRamp].
  static const int ballOnSpaceshipRamp = above + spaceshipRampBackgroundRailing;

  /// Render priority for the [Ball] while it's on the [Spaceship].
  static const int ballOnSpaceship = above + spaceshipSaucer;

  /// Render priority for the [Ball] while it's on the [SpaceshipRail].
  static const int ballOnSpaceshipRail = spaceshipRail;

  /// Render priority for the [Ball] while it's on the [LaunchRamp].
  static const int ballOnLaunchRamp = above + launchRamp;

  // BACKGROUND

  static const int background = 3 * below + base;

  // BOUNDARIES

  static const int bottomBoundary = above + dinoBottomWall;

  static const int outerBoudary = above + background;

  // BOTTOM GROUP

  static const int bottomGroup = above + ballOnBoard;

  // LAUNCHER

  static const int launchRamp = above + outerBoudary;

  static const int launchRampForegroundRailing = above + ballOnLaunchRamp;

  static const int plunger = launchRamp;

  static const int rocket = above + bottomBoundary;

  // DINO LAND

  static const int dinoTopWall = above + ballOnBoard;

  static const int dino = above + dinoTopWall;

  static const int dinoBottomWall = above + dino;

  static const int slingshot = above + ballOnBoard;

  // FLUTTER FOREST

  static const int flutterSignPost = above + launchRampForegroundRailing;

  static const int dashBumper = above + ballOnBoard;

  static const int dashAnimatronic = above + launchRampForegroundRailing;

  // SPARKY FIRE ZONE

  static const int computerBase = below + ballOnBoard;

  static const int computerTop = above + ballOnBoard;

  static const int sparkyAnimatronic = above + spaceshipRampForegroundRailing;

  static const int sparkyBumper = above + ballOnBoard;

  // ANDROID SPACESHIP

  static const int spaceshipRail = above + bottomGroup;

  static const int spaceshipRailForeground = above + spaceshipRail;

  static const int spaceshipSaucer = above + spaceshipRail;

  static const int spaceshipSaucerWall = above + spaceshipSaucer;

  static const int androidHead = above + spaceshipSaucer;

  static const int spaceshipRamp = above + ballOnBoard;

  static const int spaceshipRampBackgroundRailing = above + spaceshipRamp;

  static const int spaceshipRampForegroundRailing = above + ballOnSpaceshipRamp;

  static const int spaceshipRampBoardOpening = below + ballOnBoard;

  static const int alienBumper = above + ballOnBoard;

  // SCORE TEXT

  static const int scoreText = above + spaceshipRampForegroundRailing;
}

/// Helper methods to change the [priority] of a [Component].
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
