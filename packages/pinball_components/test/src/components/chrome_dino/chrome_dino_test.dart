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
    flameTester.test(
      'loads correctly',
      (game) async {
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);

        expect(game.contains(chromeDino), isTrue);
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.ensureAdd(ChromeDino());
        game.camera.followVector2(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        final swivelAnimationDuration = game
                .descendants()
                .whereType<SpriteAnimationComponent>()
                .first
                .animation!
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

    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = _MockChromeDinoCubit();
      whenListen(
        bloc,
        const Stream<ChromeDinoState>.empty(),
        initialState: const ChromeDinoState.inital(),
      );
      when(bloc.close).thenAnswer((_) async {});
      final chromeDino = ChromeDino.test(bloc: bloc);

      await game.ensureAdd(chromeDino);
      game.remove(chromeDino);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      flameTester.test('a ChromeDinoMouthOpeningBehavior', (game) async {
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);
        expect(
          chromeDino.children
              .whereType<ChromeDinoMouthOpeningBehavior>()
              .single,
          isNotNull,
        );
      });

      flameTester.test('a ChromeDinoSwivelingBehavior', (game) async {
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);
        expect(
          chromeDino.children.whereType<ChromeDinoSwivelingBehavior>().single,
          isNotNull,
        );
      });

      flameTester.test('a ChromeDinoChompingBehavior', (game) async {
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);
        expect(
          chromeDino.children.whereType<ChromeDinoChompingBehavior>().single,
          isNotNull,
        );
      });

      flameTester.test('a ChromeDinoSpittingBehavior', (game) async {
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);
        expect(
          chromeDino.children.whereType<ChromeDinoSpittingBehavior>().single,
          isNotNull,
        );
      });

      flameTester.test('new children', (game) async {
        final component = Component();
        final chromeDino = ChromeDino(
          children: [component],
        );
        await game.ensureAdd(chromeDino);
        expect(chromeDino.children, contains(component));
      });
    });
  });
}
