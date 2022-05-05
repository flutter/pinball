// ignore_for_file: must_call_super

import 'dart:async';

import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_theme/pinball_theme.dart';

class _MockPinballPlayer extends Mock implements PinballPlayer {}

class _MockAppLocalizations extends Mock implements AppLocalizations {}

class TestGame extends Forge2DGame with FlameBloc {
  TestGame() {
    images.prefix = '';
  }
}

class PinballTestGame extends PinballGame {
  PinballTestGame({
    List<String>? assets,
    PinballPlayer? player,
    CharacterTheme? theme,
    AppLocalizations? l10n,
  })  : _assets = assets,
        super(
          player: player ?? _MockPinballPlayer(),
          characterTheme: theme ?? const DashTheme(),
          l10n: l10n ?? _MockAppLocalizations(),
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
    PinballPlayer? player,
    CharacterTheme? theme,
    AppLocalizations? l10n,
  })  : _assets = assets,
        super(
          player: player ?? _MockPinballPlayer(),
          characterTheme: theme ?? const DashTheme(),
          l10n: l10n ?? _MockAppLocalizations(),
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
    PinballPlayer? player,
    CharacterTheme? theme,
    AppLocalizations? l10n,
  }) : super(
          assets: assets,
          player: player,
          theme: theme,
          l10n: l10n ?? _MockAppLocalizations(),
        );

  @override
  Future<void> onLoad() async {
    if (_assets != null) {
      await images.loadAll(_assets!);
    }
  }
}

class EmptyKeyboardPinballTestGame extends PinballTestGame
    with HasKeyboardHandlerComponents {
  EmptyKeyboardPinballTestGame({
    List<String>? assets,
    PinballPlayer? player,
    CharacterTheme? theme,
    AppLocalizations? l10n,
  }) : super(
          assets: assets,
          player: player,
          theme: theme,
          l10n: l10n ?? _MockAppLocalizations(),
        );

  @override
  Future<void> onLoad() async {
    if (_assets != null) {
      await images.loadAll(_assets!);
    }
  }
}
