// ignore_for_file: avoid_renaming_method_parameters

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template bonus_word}
/// Loads all [BonusLetter]s to compose a [BonusWord].
/// {@endtemplate}
class BonusWord extends Component with BlocComponent<GameBloc, GameState> {
  /// {@macro bonus_word}
  BonusWord({required Vector2 position}) : _position = position;

  final Vector2 _position;

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    return (previousState?.bonusHistory.length ?? 0) <
            newState.bonusHistory.length &&
        newState.bonusHistory.last == GameBonus.word;
  }

  @override
  void onNewState(GameState state) {
    if (state.bonusHistory.last == GameBonus.word) {
      final letters = children.whereType<BonusLetter>().toList();

      for (var i = 0; i < letters.length; i++) {
        final letter = letters[i];
        letter
          ..isEnabled = false
          ..add(
            SequenceEffect(
              [
                ColorEffect(
                  i.isOdd
                      ? BonusLetter._activeColor
                      : BonusLetter._disableColor,
                  const Offset(0, 1),
                  EffectController(duration: 0.25),
                ),
                ColorEffect(
                  i.isOdd
                      ? BonusLetter._disableColor
                      : BonusLetter._activeColor,
                  const Offset(0, 1),
                  EffectController(duration: 0.25),
                ),
              ],
              repeatCount: 4,
            )..onFinishCallback = () {
                letter
                  ..isEnabled = true
                  ..add(
                    ColorEffect(
                      BonusLetter._disableColor,
                      const Offset(0, 1),
                      EffectController(duration: 0.25),
                    ),
                  );
              },
          );
      }
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final letters = GameBloc.bonusWord.split('');

    for (var i = 0; i < letters.length; i++) {
      unawaited(
        add(
          BonusLetter(
            letter: letters[i],
            index: i,
          )..initialPosition = _position - Vector2(16 - (i * 6), -30),
        ),
      );
    }
  }
}

/// {@template bonus_letter}
/// [BodyType.static] sensor component, part of a word bonus,
/// which will activate its letter after contact with a [Ball].
/// {@endtemplate}
class BonusLetter extends BodyComponent<PinballGame>
    with BlocComponent<GameBloc, GameState>, InitialPosition {
  /// {@macro bonus_letter}
  BonusLetter({
    required String letter,
    required int index,
  })  : _letter = letter,
        _index = index {
    paint = Paint()..color = _disableColor;
  }

  /// The area size of this [BonusLetter].
  static final areaSize = Vector2.all(4);

  static const _activeColor = Colors.green;
  static const _disableColor = Colors.red;

  final String _letter;
  final int _index;

  /// Indicates if a [BonusLetter] can be activated on [Ball] contact.
  ///
  /// It is disabled whilst animating and enabled again once the animation
  /// completes. The animation is triggered when [GameBonus.word] is
  /// awarded.
  bool isEnabled = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      TextComponent(
        position: Vector2(-1, -1),
        text: _letter,
        textRenderer: TextPaint(
          style: const TextStyle(fontSize: 2, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = areaSize.x / 2;

    final fixtureDef = FixtureDef(shape)..isSensor = true;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  bool listenWhen(GameState? previousState, GameState newState) {
    final wasActive = previousState?.isLetterActivated(_index) ?? false;
    final isActive = newState.isLetterActivated(_index);

    return wasActive != isActive;
  }

  @override
  void onNewState(GameState state) {
    final isActive = state.isLetterActivated(_index);

    add(
      ColorEffect(
        isActive ? _activeColor : _disableColor,
        const Offset(0, 1),
        EffectController(duration: 0.25),
      ),
    );
  }

  /// Activates this [BonusLetter], if it's not already activated.
  void activate() {
    final isActive = state?.isLetterActivated(_index) ?? false;
    if (!isActive) {
      gameRef.read<GameBloc>().add(BonusLetterActivated(_index));
    }
  }
}

/// Triggers [BonusLetter.activate] method when a [BonusLetter] and a [Ball]
/// come in contact.
class BonusLetterBallContactCallback
    extends ContactCallback<Ball, BonusLetter> {
  @override
  void begin(Ball ball, BonusLetter bonusLetter, Contact contact) {
    if (bonusLetter.isEnabled) {
      bonusLetter.activate();
    }
  }
}
