import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';

import '../helpers/helpers.dart';

class MyBlueprint extends Blueprint {
  @override
  void build() {
    add(Component());
    addAll([Component(), Component()]);
  }
}

class MyForge2dBlueprint extends Forge2DBlueprint {
  @override
  void build() {
    addContactCallback(MockContactCallback());
    addAllContactCallback([MockContactCallback(), MockContactCallback()]);
  }
}

void main() {
  group('Blueprint', () {
    test('components can be added to it', () {
      final blueprint = MyBlueprint()..build();

      expect(blueprint.components.length, equals(3));
    });

    test('adds the components to a game on attach', () {
      final mockGame = MockPinballGame();
      when(() => mockGame.addAll(any())).thenAnswer((_) async {});
      MyBlueprint().attach(mockGame);

      verify(() => mockGame.addAll(any())).called(1);
    });

    test(
      'throws assertion error when adding to an already attached blueprint',
      () async {
        final mockGame = MockPinballGame();
        when(() => mockGame.addAll(any())).thenAnswer((_) async {});
        final blueprint = MyBlueprint();
        await blueprint.attach(mockGame);

        expect(() => blueprint.add(Component()), throwsAssertionError);
        expect(() => blueprint.addAll([Component()]), throwsAssertionError);
      },
    );
  });

  group('Forge2DBlueprint', () {
    setUpAll(() {
      registerFallbackValue(SpaceshipHoleBallContactCallback());
    });

    test('callbacks can be added to it', () {
      final blueprint = MyForge2dBlueprint()..build();

      expect(blueprint.callbacks.length, equals(3));
    });

    test('adds the callbacks to a game on attach', () async {
      final mockGame = MockPinballGame();
      when(() => mockGame.addAll(any())).thenAnswer((_) async {});
      when(() => mockGame.addContactCallback(any())).thenAnswer((_) async {});
      await MyForge2dBlueprint().attach(mockGame);

      verify(() => mockGame.addContactCallback(any())).called(3);
    });

    test(
      'throws assertion error when adding to an already attached blueprint',
      () async {
        final mockGame = MockPinballGame();
        when(() => mockGame.addAll(any())).thenAnswer((_) async {});
        when(() => mockGame.addContactCallback(any())).thenAnswer((_) async {});
        final blueprint = MyForge2dBlueprint();
        await blueprint.attach(mockGame);

        expect(
          () => blueprint.addContactCallback(MockContactCallback()),
          throwsAssertionError,
        );
        expect(
          () => blueprint.addAllContactCallback([MockContactCallback()]),
          throwsAssertionError,
        );
      },
    );

    test('throws assertion error when used on a non Forge2dGame', () {
      expect(
        () => MyForge2dBlueprint().attach(FlameGame()),
        throwsAssertionError,
      );
    });
  });
}
