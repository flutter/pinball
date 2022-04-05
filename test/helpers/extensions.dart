import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

class PinballGameTest extends PinballGame {
  PinballGameTest()
      : super(
          theme: const PinballTheme(
            characterTheme: DashTheme(),
          ),
        );
}

class DebugPinballGameTest extends DebugPinballGame {
  DebugPinballGameTest()
      : super(
          theme: const PinballTheme(
            characterTheme: DashTheme(),
          ),
        );
}

class EmptyPinballGameTest extends PinballGameTest {
  @override
  Future<void> onLoad() async {}
}
