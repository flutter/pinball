// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/chrome_dino/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockChromeDinoCubit extends Mock implements ChromeDinoCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.dino.animatronic.mouth.keyName,
    Assets.images.dino.animatronic.head.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('ChromeDino', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<ChromeDino>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.world.ensureAdd(ChromeDino());
        game.camera.moveTo(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        final swivelAnimationDuration = game
                .descendants()
                .whereType<SpriteAnimationComponent>()
                .first
                .animationTicker!
                .totalDuration() /
            2;

        game.update(swivelAnimationDuration);
        await tester.pump();

        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/chrome_dino/down.png'),
        );

        game.update(swivelAnimationDuration * 0.25);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/chrome_dino/middle.png'),
        );

        game.update(swivelAnimationDuration * 0.25);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/chrome_dino/up.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'closes bloc when removed',
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockChromeDinoCubit();
        whenListen(
          bloc,
          const Stream<ChromeDinoState>.empty(),
          initialState: const ChromeDinoState.initial(),
        );
        when(bloc.close).thenAnswer((_) async {});
        final chromeDino = ChromeDino.test(bloc: bloc);

        await game.ensureAdd(chromeDino);
        await game.ready();
      },
      verify: (game, _) async {
        final chromeDino = game.descendants().whereType<ChromeDino>().single;
        game.remove(chromeDino);
        game.update(0);
        verify(chromeDino.bloc.close).called(1);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'a ChromeDinoMouthOpeningBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final chromeDino = ChromeDino();
          await game.ensureAdd(chromeDino);
          await game.ready();
        },
        verify: (game, _) async {
          final chromeDino = game.descendants().whereType<ChromeDino>().single;
          expect(
            chromeDino.children
                .whereType<ChromeDinoMouthOpeningBehavior>()
                .single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a ChromeDinoSwivelingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final chromeDino = ChromeDino();
          await game.ensureAdd(chromeDino);
          await game.ready();
        },
        verify: (game, _) async {
          final chromeDino = game.descendants().whereType<ChromeDino>().single;
          expect(
            chromeDino.children.whereType<ChromeDinoSwivelingBehavior>().single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a ChromeDinoChompingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final chromeDino = ChromeDino();
          await game.ensureAdd(chromeDino);
          await game.ready();
        },
        verify: (game, _) async {
          final chromeDino = game.descendants().whereType<ChromeDino>().single;
          expect(
            chromeDino.children.whereType<ChromeDinoChompingBehavior>().single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a ChromeDinoSpittingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final chromeDino = ChromeDino();
          await game.ensureAdd(chromeDino);
          await game.ready();
        },
        verify: (game, _) async {
          final chromeDino = game.descendants().whereType<ChromeDino>().single;
          expect(
            chromeDino.children.whereType<ChromeDinoSpittingBehavior>().single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          await game.onLoad();
          final component = Component();
          final chromeDino = ChromeDino(
            children: [component],
          );
          await game.ensureAdd(chromeDino);
          await game.ready();
        },
        verify: (game, _) async {
          final chromeDino = game.descendants().whereType<ChromeDino>().single;
          expect(chromeDino.children.whereType<Component>(), isNotEmpty);
        },
      );
    });
  });
}
