// ignore_for_file: cascade_invocations
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

  group('Elevated', () {
    test('correctly sets and gets', () {
      final component = TestBodyComponent()
        ..elevation = Elevation.spaceship.order;
      expect(component.elevation, Elevation.spaceship.order);
    });

    flameTester.test(
      'elevation correctly before being loaded',
      (game) async {
        const expectedElevation = Elevation.spaceship;
        final component = TestBodyComponent()
          ..elevation = expectedElevation.order;
        await game.ensureAdd(component);
        // TODO(alestiago): modify once component.loaded is available.
        await component.mounted;

        expect(component.elevation, equals(expectedElevation.order));
      },
    );

    flameTester.test(
      'elevation correctly before being loaded '
      'when multiple different sets',
      (game) async {
        const expectedElevation = Elevation.spaceship;
        final component = TestBodyComponent()
          ..elevation = Elevation.jetpack.order;

        expect(component.elevation, isNot(equals(expectedElevation.order)));
        component.elevation = expectedElevation.order;

        await game.ensureAdd(component);
        // TODO(alestiago): modify once component.loaded is available.
        await component.mounted;

        expect(component.elevation, expectedElevation.order);
      },
    );

    flameTester.test(
      'elevation correctly after being loaded',
      (game) async {
        const expectedElevation = Elevation.spaceship;
        final component = TestBodyComponent();
        await game.ensureAdd(component);
        component.elevation = expectedElevation.order;
        expect(component.elevation, expectedElevation.order);
      },
    );

    flameTester.test(
      'elevation correctly after being loaded '
      'when multiple different sets',
      (game) async {
        const expectedElevation = Elevation.spaceship;
        final component = TestBodyComponent();
        await game.ensureAdd(component);

        component.elevation = Elevation.jetpack.order;
        expect(component.elevation, isNot(equals(expectedElevation.order)));
        component.elevation = expectedElevation.order;

        expect(component.elevation, expectedElevation.order);
      },
    );

    flameTester.test(
      'defaults to Elevation.board '
      'when no elevation is given',
      (game) async {
        final component = TestBodyComponent();
        await game.ensureAdd(component);
        expect(component.elevation, equals(Elevation.board.order));
      },
    );
  });

  group('ElevationOrder', () {
    test('board is the lowest elevation', () {
      for (final elevation in Elevation.values) {
        if (elevation != Elevation.board) {
          expect(elevation.order, greaterThan(Elevation.board.order));
        }
      }
    });

    test('jetpack has greater elevation than board', () {
      expect(Elevation.jetpack.order, greaterThan(Elevation.board.order));
    });

    test('spaceship has greater elevation than board and next ramps', () {
      expect(Elevation.spaceship.order, greaterThan(Elevation.jetpack.order));
      expect(
        Elevation.spaceship.order,
        greaterThan(Elevation.spaceshipExitRail.order),
      );
    });

    test('spaceshipExitRail has greater elevation than board', () {
      expect(
        Elevation.spaceshipExitRail.order,
        greaterThan(Elevation.board.order),
      );
    });
  });
}
