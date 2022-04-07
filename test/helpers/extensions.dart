// ignore_for_file: must_call_super

import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

import 'helpers.dart';

class PinballGameTest extends PinballGame {
  PinballGameTest()
      : super(
          audio: MockPinballAudio(),
          theme: const PinballTheme(
            characterTheme: DashTheme(),
          ),
        );
}

class DebugPinballGameTest extends DebugPinballGame {
  DebugPinballGameTest()
      : super(
          audio: MockPinballAudio(),
          theme: const PinballTheme(
            characterTheme: DashTheme(),
          ),
        );
}

class EmptyPinballGameTest extends PinballGameTest {
  @override
  Future<void> onLoad() async {}
}
