// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() => world.createBody(BodyDef());
}

class _TestContactBehavior extends ContactBehavior {
  int beginContactCallsCount = 0;
  @override
  void beginContact(Object other, Contact contact) {
    beginContactCallsCount++;
    super.beginContact(other, contact);
  }

  int endContactCallsCount = 0;
  @override
  void endContact(Object other, Contact contact) {
    endContactCallsCount++;
    super.endContact(other, contact);
  }

  int preSolveContactCallsCount = 0;
  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    preSolveContactCallsCount++;
    super.preSolve(other, contact, oldManifold);
  }

  int postSolveContactCallsCount = 0;
  @override
  void postSolve(Object other, Contact contact, ContactImpulse impulse) {
    postSolveContactCallsCount++;
    super.postSolve(other, contact, impulse);
  }
}

class _MockContactCallbacks extends Mock implements ContactCallbacks {}

class _MockContact extends Mock implements Contact {}

class _MockManifold extends Mock implements Manifold {}

class _MockContactImpulse extends Mock implements ContactImpulse {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('ContactBehavior', () {
    late Object other;
    late Contact contact;
    late Manifold manifold;
    late ContactImpulse contactImpulse;

    setUp(() {
      other = Object();
      contact = _MockContact();
      manifold = _MockManifold();
      contactImpulse = _MockContactImpulse();
    });

    flameTester.test(
      'should add a new ContactCallbacks to the parent',
      (game) async {
        final parent = _TestBodyComponent();
        final contactBehavior = ContactBehavior();
        await parent.add(contactBehavior);
        await game.ensureAdd(parent);

        expect(parent.body.userData, contactBehavior);
      },
    );

    flameTester.test(
      "should respect the previous ContactCallbacks in the parent's userData",
      (game) async {
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        final contactCallbacks1 = _MockContactCallbacks();
        parent.body.userData = contactCallbacks1;

        final contactBehavior = ContactBehavior();
        await parent.ensureAdd(contactBehavior);

        final contactCallbacks = parent.body.userData! as ContactCallbacks;

        contactCallbacks.beginContact(other, contact);
        verify(
          () => contactCallbacks1.beginContact(other, contact),
        ).called(1);

        contactCallbacks.endContact(other, contact);
        verify(
          () => contactCallbacks1.endContact(other, contact),
        ).called(1);

        contactCallbacks.preSolve(other, contact, manifold);
        verify(
          () => contactCallbacks1.preSolve(other, contact, manifold),
        ).called(1);

        contactCallbacks.postSolve(other, contact, contactImpulse);
        verify(
          () => contactCallbacks1.postSolve(other, contact, contactImpulse),
        ).called(1);
      },
    );

    flameTester.test('can group multiple ContactBehaviors and keep listening',
        (game) async {
      final parent = _TestBodyComponent();
      await game.ensureAdd(parent);

      final contactBehavior1 = _TestContactBehavior();
      final contactBehavior2 = _TestContactBehavior();
      final contactBehavior3 = _TestContactBehavior();
      await parent.ensureAddAll([
        contactBehavior1,
        contactBehavior2,
        contactBehavior3,
      ]);

      final contactCallbacks = parent.body.userData! as ContactCallbacks;

      contactCallbacks.beginContact(other, contact);
      expect(contactBehavior1.beginContactCallsCount, equals(1));
      expect(contactBehavior2.beginContactCallsCount, equals(1));
      expect(contactBehavior3.beginContactCallsCount, equals(1));

      contactCallbacks.endContact(other, contact);
      expect(contactBehavior1.endContactCallsCount, equals(1));
      expect(contactBehavior2.endContactCallsCount, equals(1));
      expect(contactBehavior3.endContactCallsCount, equals(1));

      contactCallbacks.preSolve(other, contact, manifold);
      expect(contactBehavior1.preSolveContactCallsCount, equals(1));
      expect(contactBehavior2.preSolveContactCallsCount, equals(1));
      expect(contactBehavior3.preSolveContactCallsCount, equals(1));

      contactCallbacks.postSolve(other, contact, contactImpulse);
      expect(contactBehavior1.postSolveContactCallsCount, equals(1));
      expect(contactBehavior2.postSolveContactCallsCount, equals(1));
      expect(contactBehavior3.postSolveContactCallsCount, equals(1));
    });
  });
}
