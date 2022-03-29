// ignore_for_file: comment_references
// TODO(alestiago): Revisit ignore lint rule once Kicker is moved to this
// package.

import 'package:pinball_components/pinball_components.dart';

/// Indicates a side of the board.
///
/// Usually used to position or mirror elements of a [PinballGame]; such as a
/// [Flipper] or [Kicker].
enum BoardSide {
  /// The left side of the board.
  left,

  /// The right side of the board.
  right,
}

/// Utility methods for [BoardSide].
extension BoardSideX on BoardSide {
  /// Whether this side is [BoardSide.left].
  bool get isLeft => this == BoardSide.left;

  /// Whether this side is [BoardSide.right].
  bool get isRight => this == BoardSide.right;

  /// Direction of the [BoardSide].
  ///
  /// Represents the path which the [BoardSide] moves along.
  int get direction => isLeft ? -1 : 1;
}
