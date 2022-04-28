// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_flame/pinball_flame.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Blueprint', () {
    final flameTester = FlameTester(FlameGame.new);

    test('correctly sets and gets components', () {
      final component1 = Component();
      final component2 = Component();
      final blueprint = Blueprint(
        components: [
          component1,
          component2,
        ],
      );

      expect(blueprint.components.length, 2);
      expect(blueprint.components, contains(component1));
      expect(blueprint.components, contains(component2));
    });

    test('correctly sets and gets blueprints', () {
      final blueprint2 = Blueprint(
        components: [Component()],
      );
      final blueprint1 = Blueprint(
        components: [Component()],
        blueprints: [blueprint2],
      );

      expect(blueprint1.blueprints, contains(blueprint2));
    });

    flameTester.test('adds the components to parent on attach', (game) async {
      final blueprint = Blueprint(
        components: [
          Component(),
          Component(),
        ],
      );
      await game.addFromBlueprint(blueprint);
      await game.ready();

      for (final component in blueprint.components) {
        expect(game.children.contains(component), isTrue);
      }
    });

    flameTester.test('adds components from a child Blueprint', (game) async {
      final childBlueprint = Blueprint(
        components: [
          Component(),
          Component(),
        ],
      );
      final parentBlueprint = Blueprint(
        components: [
          Component(),
          Component(),
        ],
        blueprints: [
          childBlueprint,
        ],
      );

      await game.addFromBlueprint(parentBlueprint);
      await game.ready();

      for (final component in childBlueprint.components) {
        expect(game.children, contains(component));
        expect(parentBlueprint.components, contains(component));
      }
      for (final component in parentBlueprint.components) {
        expect(game.children, contains(component));
      }
    });
  });
}
