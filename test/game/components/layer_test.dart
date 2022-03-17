// ignore_for_file: cascade_invocations
import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

class TestBodyComponent extends BodyComponent with Layered {
  @override
  Body createBody() {
    final fixtureDef = FixtureDef(CircleShape());
    return world.createBody(BodyDef())..createFixture(fixtureDef);
  }
}

void main() {
  final flameTester = FlameTester(Forge2DGame.new);
  group('Layered', () {
    void _expectLayerOnFixtures({
      required List<Fixture> fixtures,
      required Layer layer,
    }) {
      for (final fixture in fixtures) {
        expect(
          fixture.filterData.categoryBits,
          equals(layer._maskBits),
        );
        expect(fixture.filterData.maskBits, equals(layer._maskBits));
      }
    }

    flameTester.test('TestBodyComponent has fixtures', (game) async {
      final component = TestBodyComponent();
      await game.ensureAdd(component);
      expect(component.body.fixtures.length, greaterThan(0));
    });

    test('correctly sets and gets', () {
      final component = TestBodyComponent()..layer = Layer.jetpack;
      expect(component.layer, Layer.jetpack);
    });

    flameTester.test(
      'layers correctly before being loaded',
      (game) async {
        const expectedLayer = Layer.jetpack;
        final component = TestBodyComponent()..layer = expectedLayer;
        await game.ensureAdd(component);
        // TODO(alestiago): modify once component.loaded is available.
        await component.mounted;

        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: expectedLayer,
        );
      },
    );

    flameTester.test(
      'layers correctly before being loaded '
      'when multiple different sets',
      (game) async {
        const expectedLayer = Layer.launcher;
        final component = TestBodyComponent()..layer = Layer.jetpack;

        expect(component.layer, isNot(equals(expectedLayer)));
        component.layer = expectedLayer;

        await game.ensureAdd(component);
        // TODO(alestiago): modify once component.loaded is available.
        await component.mounted;

        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: expectedLayer,
        );
      },
    );

    flameTester.test(
      'layers correctly after being loaded',
      (game) async {
        const expectedLayer = Layer.jetpack;
        final component = TestBodyComponent();
        await game.ensureAdd(component);
        component.layer = expectedLayer;
        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: expectedLayer,
        );
      },
    );

    flameTester.test(
      'layers correctly after being loaded '
      'when multiple different sets',
      (game) async {
        const expectedLayer = Layer.launcher;
        final component = TestBodyComponent();
        await game.ensureAdd(component);

        component.layer = Layer.jetpack;
        expect(component.layer, isNot(equals(expectedLayer)));
        component.layer = expectedLayer;

        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: expectedLayer,
        );
      },
    );

    flameTester.test(
      'defaults to Layer.all '
      'when no layer is given',
      (game) async {
        final component = TestBodyComponent();
        await game.ensureAdd(component);
        expect(component.layer, equals(Layer.all));
      },
    );
  });

  group('Layer', () {
    test('has four values', () {
      expect(Layer.values.length, equals(5));
    });
  });

  group('LayerMaskBits', () {
    test('all types are different', () {
      expect(Layer.all._maskBits, isNot(equals(Layer.board._maskBits)));
      expect(Layer.board._maskBits, isNot(equals(Layer.opening._maskBits)));
      expect(Layer.opening._maskBits, isNot(equals(Layer.jetpack._maskBits)));
      expect(Layer.jetpack._maskBits, isNot(equals(Layer.launcher._maskBits)));
      expect(Layer.launcher._maskBits, isNot(equals(Layer.board._maskBits)));
    });

    test('ensure all maskBits are 16 bits max size', () {
      final maxMaskBitSize = math.pow(2, 16);
      for (final layer in Layer.values) {
        expect(layer._maskBits, isNot(greaterThan(maxMaskBitSize)));
      }
    });
  });
}
