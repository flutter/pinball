import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

extension BodyTrace on BodyComponent {
  void trace({Color color = const Color(0xFFFF0000)}) {
    paint = Paint()..color = color;
    renderBody = true;

    unawaited(
      mounted.whenComplete(() {
        final sprite = children.whereType<SpriteComponent>().first;
        sprite.paint.color = sprite.paint.color.withOpacity(0.5);
      }),
    );
  }
}
