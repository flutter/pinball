// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';

import '../../helpers/helpers.dart';
import 'layer_test.dart';

class MockContactImpulse extends Mock implements ContactImpulse {}

class MockManifold extends Mock implements Manifold {}

class TestHeavyBodyComponent extends BodyComponent {
  @override
  Body createBody() {
    final shape = CircleShape();
    return world.createBody(
      BodyDef(
        type: BodyType.dynamic,
      ),
    )..createFixtureFromShape(shape, 20);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('BumpingBehavior', () {
    flameTester.test('can be added', (game) async {
      final behavior = BumpingBehavior(strength: 0);
      final component = TestBodyComponent();
      await component.add(behavior);
      await game.ensureAdd(component);
    });

    flameTester.testGameWidget(
      'the bump is greater when the strengh is greater',
      setUp: (game, tester) async {
        final component1 = TestBodyComponent();
        final behavior1 = BumpingBehavior(strength: 1);
        await component1.add(behavior1);

        final component2 = TestBodyComponent();
        final behavior2 = BumpingBehavior(strength: 2);
        await component2.add(behavior2);

        final dummy1 = TestHeavyBodyComponent();
        final dummy2 = TestHeavyBodyComponent();

        await game.ensureAddAll([
          component1,
          component2,
          dummy1,
          dummy2,
        ]);

        expect(dummy1.body.inverseMass, greaterThan(0));
        expect(dummy2.body.inverseMass, greaterThan(0));

        final contact = MockContact();
        final manifold = MockManifold();
        final contactImpulse = MockContactImpulse();
        when(() => manifold.localPoint).thenReturn(Vector2.all(1));
        when(() => contact.manifold).thenReturn(manifold);

        behavior1.postSolve(dummy1, contact, contactImpulse);
        behavior2.postSolve(dummy2, contact, contactImpulse);

        expect(
          dummy2.body.linearVelocity.x,
          greaterThan(dummy1.body.linearVelocity.x),
        );
        expect(
          dummy2.body.linearVelocity.y,
          greaterThan(dummy1.body.linearVelocity.y),
        );
      },
    );
  });
}
