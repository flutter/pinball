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

class TestPositionedBodyComponent extends BodyComponent with InitialPosition {
  @override
  Body createBody() {
    return world.createBody(BodyDef()..position = initialPosition);
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

    flameTester.test(
      'returns normally '
      'when the body sets the position to initial position',
      (game) async {
        final component = TestPositionedBodyComponent()
          ..initialPosition = Vector2.zero();

        await expectLater(
          () async => game.ensureAdd(component),
          returnsNormally,
        );
      },
    );

    flameTester.test(
      'throws AssertionError '
      'when not setting initialPosition to body',
      (game) async {
        final component = TestBodyComponent()..initialPosition = Vector2.zero();
        await game.ensureAdd(component);

        await expectLater(
          () async => game.ensureAdd(component),
          throwsAssertionError,
        );
      },
    );
  });
}
