// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/dino_desert/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.dino.animatronic.head.keyName,
    Assets.images.dino.animatronic.mouth.keyName,
    Assets.images.dino.topWall.keyName,
    Assets.images.dino.topWallTunnel.keyName,
    Assets.images.dino.bottomWall.keyName,
    Assets.images.slingshot.upper.keyName,
    Assets.images.slingshot.lower.keyName,
  ];

  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('DinoDesert', () {
    flameTester.test('loads correctly', (game) async {
      final component = DinoDesert();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    group('loads', () {
      flameTester.test(
        'a ChromeDino',
        (game) async {
          await game.ensureAdd(DinoDesert());
          expect(
            game.descendants().whereType<ChromeDino>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'DinoWalls',
        (game) async {
          await game.ensureAdd(DinoDesert());
          expect(
            game.descendants().whereType<DinoWalls>().length,
            equals(1),
          );
        },
      );
      flameTester.test(
        'Slingshots',
        (game) async {
          await game.ensureAdd(DinoDesert());
          expect(
            game.descendants().whereType<Slingshots>().length,
            equals(1),
          );
        },
      );
    });

    group('adds', () {
      flameTester.test(
        'ScoringBehavior to ChromeDino',
        (game) async {
          await game.ensureAdd(DinoDesert());

          final chromeDino = game.descendants().whereType<ChromeDino>().single;
          expect(
            chromeDino.firstChild<ScoringBehavior>(),
            isNotNull,
          );
        },
      );

      flameTester.test('a ChromeDinoBonusBehavior', (game) async {
        final dinoDesert = DinoDesert();
        await game.ensureAdd(dinoDesert);
        expect(
          dinoDesert.children.whereType<ChromeDinoBonusBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
