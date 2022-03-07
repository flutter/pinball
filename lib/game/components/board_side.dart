import 'package:pinball/game/game.dart';

/// Indicates a side of the board.
///
/// Usually used to position or mirror elements of a [PinballGame]; such as a
/// [Flipper].
enum BoardSide {
  /// The left side of the board.
  left,

  /// The right side of the board.
  right,
}
