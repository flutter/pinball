// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';

import '../../helpers/helpers.dart';

class _MockContact extends Mock implements Contact {}

class _MockContactImpulse extends Mock implements ContactImpulse {}

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() {
    final shape = CircleShape();
    return world.createBody(
      BodyDef(type: BodyType.dynamic),
    )..createFixtureFromShape(shape, 20);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('BumpingBehavior', () {
    flameTester.test('can be added', (game) async {
      final behavior = BumpingBehavior(strength: 0);
      final component = _TestBodyComponent();
      await component.add(behavior);
      await game.ensureAdd(component);
    });

    flameTester.testGameWidget(
      'the bump is greater when the strengh is greater',
      setUp: (game, tester) async {
        final component1 = _TestBodyComponent();
        final behavior1 = BumpingBehavior(strength: 1)
          ..worldManifold.normal.setFrom(Vector2.all(1));
        await component1.add(behavior1);

        final component2 = _TestBodyComponent();
        final behavior2 = BumpingBehavior(strength: 2)
          ..worldManifold.normal.setFrom(Vector2.all(1));
        await component2.add(behavior2);

        final other1 = _TestBodyComponent();
        final other2 = _TestBodyComponent();

        await game.ensureAddAll([
          component1,
          component2,
          other1,
          other2,
        ]);

        final contact = _MockContact();
        final contactImpulse = _MockContactImpulse();

        behavior1.postSolve(other1, contact, contactImpulse);
        behavior2.postSolve(other2, contact, contactImpulse);

        expect(
          other2.body.linearVelocity.x,
          greaterThan(other1.body.linearVelocity.x),
        );
        expect(
          other2.body.linearVelocity.y,
          greaterThan(other1.body.linearVelocity.y),
        );
      },
    );
  });
}
