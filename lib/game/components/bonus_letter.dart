import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';

class BonusLetter extends BodyComponent<PinballGame> {
  BonusLetter({
    required Vector2 position,
    required String letter,
    required int index,
  })  : _position = position,
        _letter = letter,
        _index = index {
    paint = _disablePaint;
  }

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
      )..flipVertically(),
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
}
