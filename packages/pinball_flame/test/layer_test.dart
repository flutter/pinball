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

    flameTester.testGameWidget(
      'TestBodyComponent has fixtures',
      setUp: (game, _) async {
        final component = _TestBodyComponent();
        await game.ensureAdd(component);
      },
    );

    test('correctly sets and gets', () {
      final component = _TestLayeredBodyComponent()
        ..layer = Layer.spaceshipEntranceRamp;
      expect(component.layer, Layer.spaceshipEntranceRamp);
    });

    flameTester.testGameWidget(
      'layers correctly before being loaded',
      setUp: (game, _) async {
        final component = _TestLayeredBodyComponent()
          ..layer = Layer.spaceshipEntranceRamp;
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        final component =
            game.descendants().whereType<_TestLayeredBodyComponent>().single;
        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: Layer.spaceshipEntranceRamp,
        );
      },
    );

    flameTester.testGameWidget(
      'layers correctly before being loaded '
      'when multiple different sets',
      setUp: (game, _) async {
        const expectedLayer = Layer.launcher;
        final component = _TestLayeredBodyComponent()
          ..layer = Layer.spaceshipEntranceRamp;

        expect(component.layer, isNot(equals(expectedLayer)));
        component.layer = expectedLayer;

        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        final component =
            game.descendants().whereType<_TestLayeredBodyComponent>().single;
        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: Layer.launcher,
        );
      },
    );

    flameTester.testGameWidget(
      'layers correctly after being loaded',
      setUp: (game, _) async {
        const expectedLayer = Layer.spaceshipEntranceRamp;
        final component = _TestLayeredBodyComponent();
        await game.ensureAdd(component);
        component.layer = expectedLayer;
      },
      verify: (game, _) async {
        final component =
            game.descendants().whereType<_TestLayeredBodyComponent>().single;
        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: Layer.spaceshipEntranceRamp,
        );
      },
    );

    flameTester.testGameWidget(
      'layers correctly after being loaded '
      'when multiple different sets',
      setUp: (game, _) async {
        const expectedLayer = Layer.launcher;
        final component = _TestLayeredBodyComponent();
        await game.ensureAdd(component);

        component.layer = Layer.spaceshipEntranceRamp;
        expect(component.layer, isNot(equals(expectedLayer)));
        component.layer = expectedLayer;
      },
      verify: (game, _) async {
        final component =
            game.descendants().whereType<_TestLayeredBodyComponent>().single;
        _expectLayerOnFixtures(
          fixtures: component.body.fixtures,
          layer: Layer.launcher,
        );
      },
    );

    flameTester.testGameWidget(
      'defaults to Layer.all '
      'when no layer is given',
      setUp: (game, _) async {
        final component = _TestLayeredBodyComponent();
        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        final component =
            game.descendants().whereType<_TestLayeredBodyComponent>().single;
        expect(component.layer, equals(Layer.all));
      },
    );

    flameTester.testGameWidget(
      'nested Layered children will keep their layer',
      setUp: (game, _) async {
        const parentLayer = Layer.spaceshipEntranceRamp;
        const childLayer = Layer.board;

        final component = _TestLayeredBodyComponent()..layer = parentLayer;
        final childComponent = _TestLayeredBodyComponent()..layer = childLayer;
        await component.add(childComponent);

        await game.ensureAdd(component);
        expect(childLayer, isNot(equals(parentLayer)));
      },
      verify: (game, _) async {
        final component =
            game.children.whereType<_TestLayeredBodyComponent>().single;
        for (final child in component.children) {
          expect(
            (child as _TestLayeredBodyComponent).layer,
            equals(Layer.board),
          );
        }
      },
    );

    flameTester.testGameWidget(
      'nested children will keep their layer',
      setUp: (game, _) async {
        const parentLayer = Layer.spaceshipEntranceRamp;

        final component = _TestLayeredBodyComponent()..layer = parentLayer;
        final childComponent = _TestBodyComponent();
        await component.add(childComponent);

        await game.ensureAdd(component);
      },
      verify: (game, _) async {
        final component =
            game.descendants().whereType<_TestLayeredBodyComponent>().single;
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
