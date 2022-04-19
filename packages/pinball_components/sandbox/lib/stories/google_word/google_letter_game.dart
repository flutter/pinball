import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class GoogleLetterGame extends BasicBallGame {
  GoogleLetterGame() : super(color: const Color(0xFF009900));

  static const info = '''
    Shows how a GoogleLetter is rendered.
      
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    world.setContactListener(_WorldContactListener());

    camera.followVector2(Vector2.zero());
    await add(GoogleLetter(0));

    await traceAllBodies();
  }
}

class _WorldContactListener extends ContactListener {
  @override
  void beginContact(Contact contact) {
    [
      contact.bodyA.userData,
      contact.bodyB.userData,
    ].whereType<GoogleLetter>().first.activate();
  }

  @override
  void endContact(Contact contact) {}

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {}

  @override
  void preSolve(Contact contact, Manifold oldManifold) {}
}
