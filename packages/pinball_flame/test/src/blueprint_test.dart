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

    flameTester.test('adds the components to parent on attach', (game) async {
      final blueprint = Blueprint(
        components: [
          Component(),
          Component(),
        ],
      );
      await game.addFromBlueprint(blueprint);

      expect(
        game.children.length,
        equals(blueprint.components.length),
      );
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
