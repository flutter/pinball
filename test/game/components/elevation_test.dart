// ignore_for_file: cascade_invocations
import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/elevation.dart';
import 'package:pinball/game/game.dart';

class TestBodyComponent extends BodyComponent with Elevated {
  @override
  Body createBody() {
    final fixtureDef = FixtureDef(CircleShape());
    return world.createBody(BodyDef())..createFixture(fixtureDef);
  }
}

void main() {
  final flameTester = FlameTester(Forge2DGame.new);

  group('Prioritized', () {
    test('correctly sets and gets', () {
      final component = TestBodyComponent()
        ..elevation = Elevation.spaceship.order;
      expect(component.elevation, Elevation.spaceship);
    });

    flameTester.test(
      'priority correctly before being loaded',
      (game) async {
        const expectedPriority = Elevation.spaceship;
        final component = TestBodyComponent()
          ..elevation = expectedPriority.order;
        await game.ensureAdd(component);
        // TODO(alestiago): modify once component.loaded is available.
        await component.mounted;

        expect(component.elevation, equals(expectedPriority));
      },
    );

    flameTester.test(
      'priority correctly before being loaded '
      'when multiple different sets',
      (game) async {
        const expectedPriority = Elevation.spaceship;
        final component = TestBodyComponent()
          ..elevation = Elevation.jetpack.order;

        expect(component.elevation, isNot(equals(expectedPriority)));
        component.elevation = expectedPriority.order;

        await game.ensureAdd(component);
        // TODO(alestiago): modify once component.loaded is available.
        await component.mounted;

        expect(component.elevation, expectedPriority);
      },
    );

    flameTester.test(
      'priority correctly after being loaded',
      (game) async {
        const expectedPriority = Elevation.spaceship;
        final component = TestBodyComponent();
        await game.ensureAdd(component);
        component.elevation = expectedPriority.order;
        expect(component.elevation, expectedPriority);
      },
    );

    flameTester.test(
      'priority correctly after being loaded '
      'when multiple different sets',
      (game) async {
        const expectedPriority = Elevation.spaceship;
        final component = TestBodyComponent();
        await game.ensureAdd(component);

        component.elevation = Elevation.jetpack.order;
        expect(component.elevation, isNot(equals(expectedPriority)));
        component.elevation = expectedPriority.order;

        expect(component.elevation, expectedPriority);
      },
    );

    flameTester.test(
      'defaults to Priority.board '
      'when no priority is given',
      (game) async {
        final component = TestBodyComponent();
        await game.ensureAdd(component);
        expect(component.elevation, equals(Elevation.board));
      },
    );
  });

  group('PriorityOrder', () {
    test('board is the lowest priority', () {
      for (final priority in Elevation.values) {
        if (priority != Elevation.board) {
          expect(priority.order, greaterThan(Elevation.board.order));
        }
      }
    });

    test('jetpack has greater priority than board', () {
      expect(Elevation.jetpack.order, greaterThan(Elevation.board.order));
    });

    test('spaceship has greater priority than board and next ramps', () {
      expect(Elevation.spaceship.order, greaterThan(Elevation.jetpack.order));
      expect(
        Elevation.spaceship.order,
        greaterThan(Elevation.spaceshipExitRail.order),
      );
    });

    test('spaceshipExitRail has greater priority than board', () {
      expect(
        Elevation.spaceshipExitRail.order,
        greaterThan(Elevation.board.order),
      );
    });
  });
}
