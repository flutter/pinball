import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

extension BodyTrace on BodyComponent {
  void trace({Color color = const Color(0xFFFF0000)}) {
    paint = Paint()..color = color;
    renderBody = true;

    unawaited(
      mounted.whenComplete(() {
        final sprite = children.whereType<SpriteComponent>().first;
        sprite.paint.color = sprite.paint.color.withOpacity(0.5);

        descendants().whereType<JointAnchor>().forEach((anchor) {
          final fixtureDef = FixtureDef(CircleShape()..radius = 0.5);
          anchor.body.createFixture(fixtureDef);
          anchor.renderBody = true;
        });
      }),
    );
  }
}

mixin Traceable on Forge2DGame {
  late final bool trace;

  Future<void> traceAllBodies({
    Color color = const Color(0xFFFF0000),
  }) async {
    if (trace) {
      await ready();
      children
          .whereType<BodyComponent>()
          .forEach((bodyComponent) => bodyComponent.trace());
    }
  }
}
