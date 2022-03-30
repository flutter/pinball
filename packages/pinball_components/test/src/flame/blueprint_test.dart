import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class MyBlueprint extends Blueprint {
  @override
  void build(_) {
    add(Component());
    addAll([Component(), Component()]);
  }
}

class MyOtherBlueprint extends Blueprint {
  @override
  void build(_) {
    add(Component());
  }
}

class YetMyOtherBlueprint extends Blueprint {
  @override
  void build(_) {
    add(Component());
  }
}

class MyComposedBlueprint extends Blueprint {
  @override
  void build(_) {
    addBlueprint(MyBlueprint());
    addAllBlueprints([MyOtherBlueprint(), YetMyOtherBlueprint()]);
  }
}

class MyForge2dBlueprint extends Forge2DBlueprint {
  @override
  void build(_) {
    addContactCallback(MockContactCallback());
    addAllContactCallback([MockContactCallback(), MockContactCallback()]);
  }
}

void main() {
  group('Blueprint', () {
    setUpAll(() {
      registerFallbackValue(MyBlueprint());
      registerFallbackValue(Component());
    });

    test('components can be added to it', () {
      final blueprint = MyBlueprint()..build(MockGame());

      expect(blueprint.components.length, equals(3));
    });

    test('blueprints can be added to it', () {
      final blueprint = MyComposedBlueprint()..build(MockGame());

      expect(blueprint.blueprints.length, equals(3));
    });

    test('adds the components to a game on attach', () {
      final mockGame = MockGame();
      when(() => mockGame.addAll(any())).thenAnswer((_) async {});
      MyBlueprint().attach(mockGame);

      verify(() => mockGame.addAll(any())).called(1);
    });

    test('adds components from a child Blueprint the to a game on attach', () {
      final mockGame = MockGame();
      when(() => mockGame.addAll(any())).thenAnswer((_) async {});
      MyComposedBlueprint().attach(mockGame);

      verify(() => mockGame.addAll(any())).called(4);
    });

    test(
      'throws assertion error when adding to an already attached blueprint',
      () async {
        final mockGame = MockGame();
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
      final blueprint = MyForge2dBlueprint()..build(MockGame());

      expect(blueprint.callbacks.length, equals(3));
    });

    test('adds the callbacks to a game on attach', () async {
      final mockGame = MockGame();
      when(() => mockGame.addAll(any())).thenAnswer((_) async {});
      when(() => mockGame.addContactCallback(any())).thenAnswer((_) async {});
      await MyForge2dBlueprint().attach(mockGame);

      verify(() => mockGame.addContactCallback(any())).called(3);
    });

    test(
      'throws assertion error when adding to an already attached blueprint',
      () async {
        final mockGame = MockGame();
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
  });
}
