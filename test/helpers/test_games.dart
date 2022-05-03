// ignore_for_file: must_call_super

import 'dart:async';

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_theme/pinball_theme.dart';

class _MockPinballAudio extends Mock implements PinballAudio {}

class TestGame extends Forge2DGame with FlameBloc {
  TestGame() {
    images.prefix = '';
  }
}

class PinballTestGame extends PinballGame {
  PinballTestGame({
    List<String>? assets,
    PinballAudio? audio,
    CharacterTheme? theme,
  })  : _assets = assets,
        super(
          audio: audio ?? _MockPinballAudio(),
          characterTheme: theme ?? const DashTheme(),
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
  DebugPinballTestGame({
    List<String>? assets,
    PinballAudio? audio,
    CharacterTheme? theme,
  })  : _assets = assets,
        super(
          audio: audio ?? _MockPinballAudio(),
          characterTheme: theme ?? const DashTheme(),
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
  EmptyPinballTestGame({
    List<String>? assets,
    PinballAudio? audio,
    CharacterTheme? theme,
  }) : super(
          assets: assets,
          audio: audio,
          theme: theme,
        );

  @override
  Future<void> onLoad() async {
    if (_assets != null) {
      await images.loadAll(_assets!);
    }
  }
}
