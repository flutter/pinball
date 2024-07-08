// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_flame/pinball_flame.dart';

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() {
    final shape = CircleShape()..radius = 1;
    return world.createBody(BodyDef())..createFixtureFromShape(shape);
  }
}

class _TestLayeredBodyComponent extends _TestBodyComponent with Layered {
  _TestLayeredBodyComponent({required Layer layer}) {
    layer = layer;
  }
}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('LayerContactBehavior', () {
    test('can be instantiated', () {
      expect(
        LayerContactBehavior(layer: Layer.all),
        isA<LayerContactBehavior>(),
      );
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final behavior = LayerContactBehavior(layer: Layer.all);
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final parent =
            game.descendants().whereType<_TestBodyComponent>().single;
        expect(
          parent.children.whereType<LayerContactBehavior>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'beginContact changes layer',
      setUp: (game, _) async {
        final behavior = LayerContactBehavior(layer: Layer.board);
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final component = _TestLayeredBodyComponent(layer: Layer.all);
        final behavior =
            game.descendants().whereType<LayerContactBehavior>().single;

        behavior.beginContact(component, _MockContact());

        expect(component.layer, Layer.board);
      },
    );

    flameTester.testGameWidget(
      'endContact changes layer',
      setUp: (game, _) async {
        final behavior = LayerContactBehavior(
          layer: Layer.board,
          onBegin: false,
        );
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final component = _TestLayeredBodyComponent(layer: Layer.all);
        final behavior =
            game.descendants().whereType<LayerContactBehavior>().single;

        behavior.endContact(component, _MockContact());

        expect(component.layer, Layer.board);
      },
    );
  });
}
