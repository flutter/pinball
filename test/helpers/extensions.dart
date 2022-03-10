import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// [PinballGame] extension to reduce boilerplate in tests.
extension PinballGameTest on PinballGame {
  /// Create [PinballGame] with default [PinballTheme].
  static PinballGame create() => PinballGame(
        theme: const PinballTheme(
          characterTheme: DashTheme(),
        ),
      );
}
