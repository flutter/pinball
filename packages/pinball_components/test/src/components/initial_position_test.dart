// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

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

    flameTester.test(
      'throws AssertionError '
      'when BodyDef is not positioned with initialPosition',
      (game) async {
        final component = TestBodyComponent()
          ..initialPosition = Vector2.all(
            10,
          );
        await expectLater(
          () => game.ensureAdd(component),
          throwsAssertionError,
        );
      },
    );

    flameTester.test(
      'positions correctly',
      (game) async {
        final position = Vector2.all(10);
        final component = TestPositionedBodyComponent()
          ..initialPosition = position;
        await game.ensureAdd(component);
        expect(component.body.position, equals(position));
      },
    );

    flameTester.test(
      'deafaults to zero '
      'when no initialPosition is given',
      (game) async {
        final component = TestBodyComponent();
        await game.ensureAdd(component);
        expect(component.body.position, equals(Vector2.zero()));
      },
    );

    flameTester.test(
      'setting throws AssertionError '
      'when component has loaded',
      (game) async {
        final component = TestBodyComponent();
        await game.ensureAdd(component);

        expect(component.isLoaded, isTrue);
        expect(
          () => component.initialPosition = Vector2.all(4),
          throwsAssertionError,
        );
      },
    );
  });
}
