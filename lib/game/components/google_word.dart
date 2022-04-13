// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template bonus_word}
/// Loads all [GoogleLetter]s to compose a [GoogleWord].
/// {@endtemplate}
class GoogleWord extends Component
    with HasGameRef<PinballGame>, Controls<_GoogleWordController> {
  /// {@macro bonus_word}
  GoogleWord({
    required Vector2 position,
  }) : _position = position {
    controller = _GoogleWordController(this);
  }

  final Vector2 _position;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final offsets = [
      Vector2(-12.92, -1.82),
      Vector2(-8.33, 0.65),
      Vector2(-2.88, 1.75),
      Vector2(2.88, 1.75),
      Vector2(8.33, 0.65),
      Vector2(12.92, -1.82),
    ];

    final letters = <GoogleLetter>[];
    for (var index = 0; index < offsets.length; index++) {
      letters.add(
        GoogleLetter(index)..initialPosition = _position + offsets[index],
      );
    }

    await addAll(letters);
  }
}

class _GoogleWordController extends ComponentController<GoogleWord>
    with HasGameRef<PinballGame> {
  _GoogleWordController(GoogleWord googleWord) : super(googleWord);

  static const _googleWord = 'Google';

  final Set<int> _activatedIndexes = <int>{};

  void activate(int index) {
    if (!_activatedIndexes.add(index)) return;

    component.children.whereType<GoogleLetter>().elementAt(index).activate();

    final activatedBonus = _activatedIndexes.length == _googleWord.length;
    if (activatedBonus) {
      gameRef.audio.googleBonus();
      gameRef.read<GameBloc>().add(const BonusActivated(GameBonus.word));
      component.children.whereType<GoogleLetter>().forEach(
            (letter) => letter.deactivate(),
          );
      _activatedIndexes.clear();
    }
  }
}

/// Activates a [GoogleLetter] when it contacts with a [Ball].
@visibleForTesting
class BonusLetterBallContactCallback
    extends ContactCallback<Ball, GoogleLetter> {
  @override
  void begin(Ball ball, GoogleLetter googleLetter, Contact contact) {
    (googleLetter.parent! as GoogleWord)
        .controller
        .activate(googleLetter.index);
  }
}
