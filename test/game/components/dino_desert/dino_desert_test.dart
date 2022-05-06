// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/dino_desert/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.dino.animatronic.head.keyName,
      Assets.images.dino.animatronic.mouth.keyName,
      Assets.images.dino.topWall.keyName,
      Assets.images.dino.topWallTunnel.keyName,
      Assets.images.dino.bottomWall.keyName,
      Assets.images.slingshot.upper.keyName,
      Assets.images.slingshot.lower.keyName,
    ]);
  }

  Future<void> pump(DinoDesert child) async {
    await ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: _MockGameBloc(),
        children: [child],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('DinoDesert', () {
    flameTester.test('loads correctly', (game) async {
      final component = DinoDesert();
      await game.pump(component);
      expect(game.descendants(), contains(component));
    });

    group('loads', () {
      flameTester.test(
        'a ChromeDino',
        (game) async {
          await game.pump(DinoDesert());
          expect(
            game.descendants().whereType<ChromeDino>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'DinoWalls',
        (game) async {
          await game.pump(DinoDesert());
          expect(
            game.descendants().whereType<DinoWalls>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'Slingshots',
        (game) async {
          await game.pump(DinoDesert());
          expect(
            game.descendants().whereType<Slingshots>().length,
            equals(1),
          );
        },
      );
    });

    group('adds', () {
      flameTester.test(
        'ScoringContactBehavior to ChromeDino',
        (game) async {
          await game.pump(DinoDesert());

          final chromeDino = game.descendants().whereType<ChromeDino>().single;
          expect(
            chromeDino.firstChild<ScoringContactBehavior>(),
            isNotNull,
          );
        },
      );

      flameTester.test('a ChromeDinoBonusBehavior', (game) async {
        final component = DinoDesert();
        await game.pump(component);
        expect(
          component.children.whereType<ChromeDinoBonusBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
