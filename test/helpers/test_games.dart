// ignore_for_file: must_call_super

import 'dart:async';

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
  PinballTestGame([List<String>? assets])
      : _assets = assets,
        super(
          audio: MockPinballAudio(),
          theme: const PinballTheme(
            characterTheme: DashTheme(),
          ),
        );
  final List<String>? _assets;

  @override
  Future<void> onLoad() async {
    if (_assets != null) {
      await images.loadAll(_assets!);
    }
    await super.onLoad();
  }
}

class DebugPinballTestGame extends DebugPinballGame {
  DebugPinballTestGame([List<String>? assets])
      : _assets = assets,
        super(
          audio: MockPinballAudio(),
          theme: const PinballTheme(
            characterTheme: DashTheme(),
          ),
        );

  final List<String>? _assets;

  @override
  Future<void> onLoad() async {
    if (_assets != null) {
      await images.loadAll(_assets!);
    }
    await super.onLoad();
  }
}

class EmptyPinballTestGame extends PinballTestGame {
  EmptyPinballTestGame([List<String>? assets]) : super(assets);

  @override
  Future<void> onLoad() async {
    if (_assets != null) {
      await images.loadAll(_assets!);
    }
  }
}
