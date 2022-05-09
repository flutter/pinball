// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/google_gallery/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.googleWord.letter1.lit.keyName,
      Assets.images.googleWord.letter1.dimmed.keyName,
      Assets.images.googleWord.letter2.lit.keyName,
      Assets.images.googleWord.letter2.dimmed.keyName,
      Assets.images.googleWord.letter3.lit.keyName,
      Assets.images.googleWord.letter3.dimmed.keyName,
      Assets.images.googleWord.letter4.lit.keyName,
      Assets.images.googleWord.letter4.dimmed.keyName,
      Assets.images.googleWord.letter5.lit.keyName,
      Assets.images.googleWord.letter5.dimmed.keyName,
      Assets.images.googleWord.letter6.lit.keyName,
      Assets.images.googleWord.letter6.dimmed.keyName,
      Assets.images.googleRollover.left.decal.keyName,
      Assets.images.googleRollover.left.pin.keyName,
      Assets.images.googleRollover.right.decal.keyName,
      Assets.images.googleRollover.right.pin.keyName,
    ]);
  }

  Future<void> pump(GoogleGallery child) async {
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

  group('GoogleGallery', () {
    flameTester.test('loads correctly', (game) async {
      final component = GoogleGallery();
      await game.pump(component);
      expect(game.descendants(), contains(component));
    });

    group('loads', () {
      flameTester.test(
        'two GoogleRollovers',
        (game) async {
          await game.pump(GoogleGallery());
          expect(
            game.descendants().whereType<GoogleRollover>().length,
            equals(2),
          );
        },
      );

      flameTester.test(
        'a GoogleWord',
        (game) async {
          await game.pump(GoogleGallery());
          expect(
            game.descendants().whereType<GoogleWord>().length,
            equals(1),
          );
        },
      );
    });

    group('adds', () {
      flameTester.test(
        'ScoringContactBehavior to GoogleRollovers',
        (game) async {
          await game.pump(GoogleGallery());

          game.descendants().whereType<GoogleRollover>().forEach(
                (rollover) => expect(
                  rollover.firstChild<ScoringContactBehavior>(),
                  isNotNull,
                ),
              );
        },
      );

      flameTester.test(
        'RolloverNoiseBehavior to GoogleRollovers',
        (game) async {
          await game.pump(GoogleGallery());

          game.descendants().whereType<GoogleRollover>().forEach(
                (rollover) => expect(
                  rollover.firstChild<RolloverNoiseBehavior>(),
                  isNotNull,
                ),
              );
        },
      );

      flameTester.test('a GoogleWordBonusBehavior', (game) async {
        final component = GoogleGallery();
        await game.pump(component);
        expect(
          component.descendants().whereType<GoogleWordBonusBehavior>().single,
          isNotNull,
        );
      });
    });
  });
}
