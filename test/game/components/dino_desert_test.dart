// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.dino.animatronic.head.keyName,
    Assets.images.dino.animatronic.mouth.keyName,
    Assets.images.dino.topWall.keyName,
    Assets.images.dino.bottomWall.keyName,
  ];

  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('DinoDesert', () {
    flameTester.test('loads correctly', (game) async {
      await game.addFromBlueprint(DinoDesert());
      await game.ready();
    });

    group('loads', () {
      flameTester.test(
        'a ChromeDino',
        (game) async {
          expect(
            DinoDesert().components.whereType<ChromeDino>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'DinoWalls',
        (game) async {
          expect(
            DinoDesert().blueprints.whereType<DinoWalls>().single,
            isNotNull,
          );
        },
      );
    });

    flameTester.test(
      'adds ScoringBehavior to ChromeDino',
      (game) async {
        await game.addFromBlueprint(DinoDesert());
        await game.ready();

        final chromeDino = game.descendants().whereType<ChromeDino>().single;
        expect(
          chromeDino.firstChild<ScoringBehavior>(),
          isNotNull,
        );
      },
    );
  });
}
