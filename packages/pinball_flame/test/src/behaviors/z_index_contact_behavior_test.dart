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

class _TestZIndexBodyComponent extends _TestBodyComponent with ZIndex {
  _TestZIndexBodyComponent({required int zIndex}) {
    zIndex = zIndex;
  }
}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('ZIndexContactBehavior', () {
    test('can be instantiated', () {
      expect(
        ZIndexContactBehavior(zIndex: 0),
        isA<ZIndexContactBehavior>(),
      );
    });

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final behavior = ZIndexContactBehavior(zIndex: 0);
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final parent =
            game.descendants().whereType<_TestBodyComponent>().single;
        expect(
          parent.children.whereType<ZIndexContactBehavior>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'beginContact changes zIndex',
      setUp: (game, _) async {
        final behavior = ZIndexContactBehavior(zIndex: 1);
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final behavior =
            game.descendants().whereType<ZIndexContactBehavior>().single;
        final component = _TestZIndexBodyComponent(zIndex: 0);

        behavior.beginContact(component, _MockContact());

        expect(component.zIndex, 1);
      },
    );

    flameTester.testGameWidget(
      'endContact changes zIndex',
      setUp: (game, _) async {
        final behavior = ZIndexContactBehavior(zIndex: 1, onBegin: false);
        final parent = _TestBodyComponent();
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);
      },
      verify: (game, _) async {
        final behavior =
            game.descendants().whereType<ZIndexContactBehavior>().single;
        final component = _TestZIndexBodyComponent(zIndex: 0);

        behavior.endContact(component, _MockContact());

        expect(component.zIndex, 1);
      },
    );
  });
}
