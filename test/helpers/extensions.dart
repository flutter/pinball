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

/// [DebugPinballGame] extension to reduce boilerplate in tests.
extension DebugPinballGameTest on DebugPinballGame {
  /// Create [PinballGame] with default [PinballTheme].
  static DebugPinballGame create() => DebugPinballGame(
        theme: const PinballTheme(
          characterTheme: DashTheme(),
        ),
      );
}
