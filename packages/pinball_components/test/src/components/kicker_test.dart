// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/kicker/behaviors/behaviors.dart';

import '../../helpers/helpers.dart';

class _MockKickerCubit extends Mock implements KickerCubit {}

void main() {
  group('Kicker', () {
    final assets = [
      Assets.images.kicker.left.lit.keyName,
      Assets.images.kicker.left.dimmed.keyName,
      Assets.images.kicker.right.lit.keyName,
      Assets.images.kicker.right.dimmed.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final leftKicker = Kicker(
          side: BoardSide.left,
        )
          ..initialPosition = Vector2(-20, 0)
          ..renderBody = false;
        final rightKicker = Kicker(
          side: BoardSide.right,
        )..initialPosition = Vector2(20, 0);

        await game.world.ensureAddAll([leftKicker, rightKicker]);
        game.camera.moveTo(Vector2.zero());
        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/kickers.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final kicker = Kicker.test(
          side: BoardSide.left,
          bloc: KickerCubit(),
        );
        await game.ensureAdd(kicker);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Kicker>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      'closes bloc when removed',
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockKickerCubit();
        whenListen(
          bloc,
          const Stream<KickerState>.empty(),
          initialState: KickerState.lit,
        );
        when(bloc.close).thenAnswer((_) async {});
        final kicker = Kicker.test(
          side: BoardSide.left,
          bloc: bloc,
        );

        await game.ensureAdd(kicker);
        await game.ready();
      },
      verify: (game, _) async {
        final kicker = game.descendants().whereType<Kicker>().single;
        game.remove(kicker);
        game.update(0);

        verify(kicker.bloc.close).called(1);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          await game.onLoad();
          final component = Component();
          final kicker = Kicker(
            side: BoardSide.left,
            children: [component],
          );
          await game.ensureAdd(kicker);
          await game.ready();
        },
        verify: (game, _) async {
          final kicker = game.descendants().whereType<Kicker>().single;
          expect(kicker.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final kicker = Kicker(
            side: BoardSide.left,
          );
          await game.ensureAdd(kicker);
          await game.ready();
        },
        verify: (game, _) async {
          final kicker = game.descendants().whereType<Kicker>().single;
          expect(
            kicker.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a KickerBallContactBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final kicker = Kicker(
            side: BoardSide.left,
          );
          await game.ensureAdd(kicker);
          await game.ready();
        },
        verify: (game, _) async {
          final kicker = game.descendants().whereType<Kicker>().single;
          expect(
            kicker.children.whereType<KickerBallContactBehavior>().single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a KickerBlinkingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final kicker = Kicker(
            side: BoardSide.left,
          );
          await game.ensureAdd(kicker);
          await game.ready();
        },
        verify: (game, _) async {
          final kicker = game.descendants().whereType<Kicker>().single;
          expect(
            kicker.children.whereType<KickerBlinkingBehavior>().single,
            isNotNull,
          );
        },
      );
    });
  });
}
