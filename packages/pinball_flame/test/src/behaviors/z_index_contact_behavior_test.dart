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

    flameTester.test('can be loaded', (game) async {
      final behavior = ZIndexContactBehavior(zIndex: 0);
      final parent = _TestBodyComponent();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      expect(parent.children, contains(behavior));
    });

    flameTester.test('beginContact changes zIndex', (game) async {
      const oldIndex = 0;
      const newIndex = 1;
      final behavior = ZIndexContactBehavior(zIndex: newIndex);
      final parent = _TestBodyComponent();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);

      final component = _TestZIndexBodyComponent(zIndex: oldIndex);

      behavior.beginContact(component, _MockContact());

      expect(component.zIndex, newIndex);
    });
  });
}
