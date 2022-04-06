import 'package:flame_forge2d/flame_forge2d.dart';

void beginContact(Forge2DGame game, BodyComponent bodyA, BodyComponent bodyB) {
  assert(
    bodyA.body.fixtures.isNotEmpty && bodyB.body.fixtures.isNotEmpty,
    'Bodies require fixtures to contact each other.',
  );

  final fixtureA = bodyA.body.fixtures.first;
  final fixtureB = bodyB.body.fixtures.first;
  final contact = Contact.init(fixtureA, 0, fixtureB, 0);
  game.world.contactManager.contactListener?.beginContact(contact);
}
