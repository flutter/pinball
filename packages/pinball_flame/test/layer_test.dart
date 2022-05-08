// ignore_for_file: cascade_invocations
import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestLayeredBodyComponent extends BodyComponent with Layered {
  @override
  Body createBody() {
    final fixtureDef = FixtureDef(CircleShape());
    return world.createBody(BodyDef())..createFixture(fixtureDef);
  }
}

class _TestBodyComponent extends BodyComponent {
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
      expect(fixtures.length, greaterThan(0));
      for (final fixture in fixtures) {
        expect(
          fixture.filterData.categoryBits,
          equals(layer.maskBits),
        );
        expect(fixture.filterData.maskBits, equals(layer.maskBits));
      }
    }

    flameTester.test('TestBodyComponent has fixtures', (game) async {
      final component = _TestBodyComponent();
      await game.ensureAdd(component);
    });

    test('correctly sets and gets', () {
      final component = _TestLayeredBodyComponent()
        ..layer = Layer.spaceshipEntranceRamp;
      expect(component.layer, Layer.spaceshipEntranceRamp);
    });

    flameTester.test(
      'layers correctly before being loaded',
      (game) async {
        const expectedLayer = Layer.spaceshipEntranceRamp;
        final component = _TestLayeredBodyComponent()..layer = expectedLayer;
        await game.ensureAdd(component);

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
        final component = _TestLayeredBodyComponent()
          ..layer = Layer.spaceshipEntranceRamp;

        expect(component.layer, isNot(equals(expectedLayer)));
        component.layer = expectedLayer;

        await game.ensureAdd(component);

        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: expectedLayer,
        );
      },
    );

    flameTester.test(
      'layers correctly after being loaded',
      (game) async {
        const expectedLayer = Layer.spaceshipEntranceRamp;
        final component = _TestLayeredBodyComponent();
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
        final component = _TestLayeredBodyComponent();
        await game.ensureAdd(component);

        component.layer = Layer.spaceshipEntranceRamp;
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
        final component = _TestLayeredBodyComponent();
        await game.ensureAdd(component);
        expect(component.layer, equals(Layer.all));
      },
    );

    flameTester.test(
      'nested Layered children will keep their layer',
      (game) async {
        const parentLayer = Layer.spaceshipEntranceRamp;
        const childLayer = Layer.board;

        final component = _TestLayeredBodyComponent()..layer = parentLayer;
        final childComponent = _TestLayeredBodyComponent()..layer = childLayer;
        await component.add(childComponent);

        await game.ensureAdd(component);
        expect(childLayer, isNot(equals(parentLayer)));

        for (final child in component.children) {
          expect(
            (child as _TestLayeredBodyComponent).layer,
            equals(childLayer),
          );
        }
      },
    );

    flameTester.test(
      'nested children will keep their layer',
      (game) async {
        const parentLayer = Layer.spaceshipEntranceRamp;

        final component = _TestLayeredBodyComponent()..layer = parentLayer;
        final childComponent = _TestBodyComponent();
        await component.add(childComponent);

        await game.ensureAdd(component);

        for (final child in component.children) {
          expect(
            (child as _TestBodyComponent)
                .body
                .fixtures
                .first
                .filterData
                .maskBits,
            equals(Filter().maskBits),
          );
        }
      },
    );
  });

  group('LayerMaskBits', () {
    test('all types are different', () {
      for (final layer in Layer.values) {
        for (final otherLayer in Layer.values) {
          if (layer != otherLayer) {
            expect(layer.maskBits, isNot(equals(otherLayer.maskBits)));
          }
        }
      }
    });

    test('all maskBits are smaller than 2^16 ', () {
      final maxMaskBitSize = math.pow(2, 16);
      for (final layer in Layer.values) {
        expect(layer.maskBits, isNot(greaterThan(maxMaskBitSize)));
      }
    });
  });
}
