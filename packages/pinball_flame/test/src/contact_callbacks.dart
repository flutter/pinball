import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:test/scaffolding.dart';

class MockContactCallback extends Mock implements ContactCallbacks2 {}

class MockContact extends Mock implements Contact {}

class MockBody extends Mock implements Body {}

class MockFixture extends Mock implements Fixture {}

class MockManifold extends Mock implements Manifold {}

class MockContactImpulse extends Mock implements ContactImpulse {}

void main() {
  group(
    'WorldContactListener',
    () {
      late ContactCallbacks2 contactCallback;
      late Contact contact;
      late Body bodyA;
      late Body bodyB;
      late Fixture fixtureA;
      late Fixture fixtureB;

      setUp(() {
        contactCallback = MockContactCallback();
        contact = MockContact();
        bodyA = MockBody();
        bodyB = MockBody();
        fixtureA = MockFixture();
        fixtureB = MockFixture();

        when(() => contact.bodyA).thenReturn(bodyA);
        when(() => contact.bodyB).thenReturn(bodyB);
        when(() => contact.fixtureA).thenReturn(fixtureA);
        when(() => contact.fixtureB).thenReturn(fixtureB);
      });

      setUpAll(() {
        registerFallbackValue(Object());
      });

      group(
        'preSolve',
        () {
          late Manifold manifold;

          setUp(() {
            manifold = MockManifold();
          });

          test(
            "doesn't callback if userData are null",
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(null);
              when(() => fixtureA.userData).thenReturn(null);
              when(() => fixtureB.userData).thenReturn(null);

              contactListener.preSolve(contact, manifold);

              verifyNever<void>(
                () => contactCallback.preSolve(any(), contact, manifold),
              );
            },
          );

          test(
            'callbacks for userData when not null',
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(Object());
              when(() => fixtureA.userData).thenReturn(Object());
              when(() => fixtureB.userData).thenReturn(Object());

              contactListener.preSolve(contact, manifold);

              verify<void>(
                () => contactCallback.preSolve(
                  bodyB.userData!,
                  contact,
                  manifold,
                ),
              ).called(1);
              verify<void>(
                () => contactCallback.preSolve(
                  fixtureA.userData!,
                  contact,
                  manifold,
                ),
              ).called(1);
              verify<void>(
                () => contactCallback.preSolve(
                  fixtureB.userData!,
                  contact,
                  manifold,
                ),
              ).called(1);
              verify<void>(
                () => contactCallback.preSolve(
                  any(),
                  contact,
                  manifold,
                ),
              ).called(3);
            },
          );

          test(
            "doesn't callback itself",
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(contactCallback);
              when(() => fixtureA.userData).thenReturn(null);
              when(() => fixtureB.userData).thenReturn(null);

              contactListener.preSolve(contact, manifold);

              verifyNever<void>(
                () => contactCallback.preSolve(any(), contact, manifold),
              );
            },
          );
        },
      );

      group(
        'beginContact',
        () {
          test(
            "doesn't callback if userData are null",
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(null);
              when(() => fixtureA.userData).thenReturn(null);
              when(() => fixtureB.userData).thenReturn(null);

              contactListener.beginContact(contact);

              verifyNever<void>(
                () => contactCallback.beginContact(any(), contact),
              );
            },
          );

          test(
            'callbacks for userData when not null',
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(Object());
              when(() => fixtureA.userData).thenReturn(Object());
              when(() => fixtureB.userData).thenReturn(Object());

              contactListener.beginContact(contact);

              verify<void>(
                () => contactCallback.beginContact(bodyB.userData!, contact),
              ).called(1);
              verify<void>(
                () => contactCallback.beginContact(fixtureA.userData!, contact),
              ).called(1);
              verify<void>(
                () => contactCallback.beginContact(fixtureB.userData!, contact),
              ).called(1);
              verify<void>(
                () => contactCallback.beginContact(any(), contact),
              ).called(3);
            },
          );

          test(
            "doesn't callback itself",
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(contactCallback);
              when(() => fixtureA.userData).thenReturn(null);
              when(() => fixtureB.userData).thenReturn(null);

              contactListener.beginContact(contact);

              verifyNever<void>(
                () => contactCallback.beginContact(any(), contact),
              );
            },
          );
        },
      );

      group(
        'endContact',
        () {
          test(
            "doesn't callback if userData are null",
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(null);
              when(() => fixtureA.userData).thenReturn(null);
              when(() => fixtureB.userData).thenReturn(null);

              contactListener.endContact(contact);

              verifyNever<void>(
                () => contactCallback.endContact(any(), contact),
              );
            },
          );

          test(
            'callbacks for userData when not null',
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(Object());
              when(() => fixtureA.userData).thenReturn(Object());
              when(() => fixtureB.userData).thenReturn(Object());

              contactListener.endContact(contact);

              verify<void>(
                () => contactCallback.endContact(bodyB.userData!, contact),
              ).called(1);
              verify<void>(
                () => contactCallback.endContact(fixtureA.userData!, contact),
              ).called(1);
              verify<void>(
                () => contactCallback.endContact(fixtureB.userData!, contact),
              ).called(1);
              verify<void>(
                () => contactCallback.endContact(any(), contact),
              ).called(3);
            },
          );

          test(
            "doesn't callback itself",
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(contactCallback);
              when(() => fixtureA.userData).thenReturn(null);
              when(() => fixtureB.userData).thenReturn(null);

              contactListener.endContact(contact);

              verifyNever<void>(
                () => contactCallback.endContact(any(), contact),
              );
            },
          );
        },
      );

      group(
        'postSolve',
        () {
          late ContactImpulse contactImpulse;

          setUp(() {
            contactImpulse = MockContactImpulse();
          });

          test(
            "doesn't callback if userData are null",
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(null);
              when(() => fixtureA.userData).thenReturn(null);
              when(() => fixtureB.userData).thenReturn(null);

              contactListener.postSolve(contact, contactImpulse);

              verifyNever<void>(
                () => contactCallback.postSolve(any(), contact, contactImpulse),
              );
            },
          );

          test(
            'callbacks for userData when not null',
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(Object());
              when(() => fixtureA.userData).thenReturn(Object());
              when(() => fixtureB.userData).thenReturn(Object());

              contactListener.postSolve(contact, contactImpulse);

              verify<void>(
                () => contactCallback.postSolve(
                  bodyB.userData!,
                  contact,
                  contactImpulse,
                ),
              ).called(1);
              verify<void>(
                () => contactCallback.postSolve(
                  fixtureA.userData!,
                  contact,
                  contactImpulse,
                ),
              ).called(1);
              verify<void>(
                () => contactCallback.postSolve(
                  fixtureB.userData!,
                  contact,
                  contactImpulse,
                ),
              ).called(1);
              verify<void>(
                () => contactCallback.postSolve(
                  any(),
                  contact,
                  contactImpulse,
                ),
              ).called(3);
            },
          );

          test(
            "doesn't callback itself",
            () {
              final contactListener = WorldContactListener();

              when(() => bodyA.userData).thenReturn(contactCallback);
              when(() => bodyB.userData).thenReturn(contactCallback);
              when(() => fixtureA.userData).thenReturn(null);
              when(() => fixtureB.userData).thenReturn(null);

              contactListener.postSolve(contact, contactImpulse);

              verifyNever<void>(
                () => contactCallback.postSolve(any(), contact, contactImpulse),
              );
            },
          );
        },
      );
    },
  );
}
