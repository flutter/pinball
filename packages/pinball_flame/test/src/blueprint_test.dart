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
      expect(game.children, equals(blueprint.components));
    });

    flameTester
        .test('adds components from a child Blueprint the to a game on attach',
            (game) async {
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

      expect(
        game.children,
        equals([
          ...parentBlueprint.components,
          ...childBlueprint.components,
        ]),
      );
    });
  });
}
