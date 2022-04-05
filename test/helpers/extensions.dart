import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

import 'helpers.dart';

class PinballGameTest extends PinballGame {
  PinballGameTest()
      : super(
          theme: const PinballTheme(
            characterTheme: DashTheme(),
            audio: MockPinballAudio(),
          ),
        );
}

class DebugPinballGameTest extends DebugPinballGame {
  DebugPinballGameTest()
      : super(
          theme: const PinballTheme(
            characterTheme: DashTheme(),
            audio: MockPinballAudio(),
          ),
        );
}

class EmptyPinballGameTest extends PinballGameTest {
  @override
  Future<void> onLoad() async {}
}
