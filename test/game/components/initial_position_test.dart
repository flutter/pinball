// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

class TestBodyComponent extends BodyComponent with InitialPosition {
  @override
  Body createBody() {
    return world.createBody(BodyDef());
  }
}

void main() {
  final flameTester = FlameTester(Forge2DGame.new);
  group('InitialPosition', () {
    test('correctly sets and gets', () {
      final component = TestBodyComponent()..initialPosition = Vector2(1, 2);
      expect(component.initialPosition, Vector2(1, 2));
    });

    test('can only be set once', () {
      final component = TestBodyComponent()..initialPosition = Vector2(1, 2);
      expect(
        () => component.initialPosition = Vector2(3, 4),
        throwsA(isA<Error>()),
      );
    });

    flameTester.test('positions correctly', (game) async {
      final position = Vector2.all(10);
      final component = TestBodyComponent()..initialPosition = position;
      await game.ensureAdd(component);
      expect(component.body.position, equals(position));
    });
  });
}
