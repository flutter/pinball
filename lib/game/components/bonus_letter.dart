// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

/// {@template bonus_letter}
/// A pass through, [BodyType.static] component, part of
/// a word bonus, which will active its letter once a ball
/// pass through it
/// {@endtemplate}
class BonusLetter extends BodyComponent<PinballGame>
    with BlocComponent<GameBloc, GameState> {

  /// {@macro bonus_letter}
  BonusLetter({
    required Vector2 position,
    required String letter,
    required int index,
  })  : _position = position,
        _letter = letter,
        _index = index {
    paint = _disablePaint;
  }

  /// The area size of this bonus letter
  static final areaSize = Vector2.all(4);

  static final _activePaint = Paint()..color = Colors.green;
  static final _disablePaint = Paint()..color = Colors.red;

  final Vector2 _position;
  final String _letter;
  final int _index;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await add(
      TextComponent(
        position: Vector2(-1, 1),
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
      ..userData = this
      ..position = _position
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  /// When called, will activate this letter, if still not activated
  void activate() {
    // TODO
    //gameRef.read<GameBloc>().add(BonusLetterActivated(_index));

    paint = _activePaint;
  }
}

/// Handles contact for [Ball] and [BonusLetter], which trigger [BonusLetter]
/// activate method.
class BonusLetterBallContactCallback
    extends ContactCallback<Ball, BonusLetter> {
  @override
  void begin(Ball ball, BonusLetter bonusLetter, Contact contact) {
    bonusLetter.activate();
  }
}
