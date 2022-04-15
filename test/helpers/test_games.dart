// ignore_for_file: must_call_super

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

import 'helpers.dart';

class TestGame extends Forge2DGame with FlameBloc {
  TestGame() {
    images.prefix = '';
  }
}

class PinballTestGame extends PinballGame {
  PinballTestGame()
      : super(
          audio: MockPinballAudio(),
          theme: const PinballTheme(
            characterTheme: DashTheme(),
          ),
        );
}

class DebugPinballTestGame extends DebugPinballGame {
  DebugPinballTestGame()
      : super(
          audio: MockPinballAudio(),
          theme: const PinballTheme(
            characterTheme: DashTheme(),
          ),
        );
}

class EmptyPinballTestGame extends PinballTestGame {
  @override
  Future<void> onLoad() async {}
}
