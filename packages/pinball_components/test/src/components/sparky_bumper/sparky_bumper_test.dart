// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';
import 'package:pinball_components/src/components/sparky_bumper/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

class _MockSparkyBumperCubit extends Mock implements SparkyBumperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.sparky.bumper.a.lit.keyName,
    Assets.images.sparky.bumper.a.dimmed.keyName,
    Assets.images.sparky.bumper.b.lit.keyName,
    Assets.images.sparky.bumper.b.dimmed.keyName,
    Assets.images.sparky.bumper.c.lit.keyName,
    Assets.images.sparky.bumper.c.dimmed.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('SparkyBumper', () {
    flameTester.testGameWidget(
      '"a" loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final sparkyBumper = SparkyBumper.a();
        await game.ensureAdd(sparkyBumper);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<SparkyBumper>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      '"b" loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final sparkyBumper = SparkyBumper.b();
        await game.ensureAdd(sparkyBumper);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<SparkyBumper>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      '"c" loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final sparkyBumper = SparkyBumper.c();
        await game.ensureAdd(sparkyBumper);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<SparkyBumper>().length, equals(1));
      },
    );

    flameTester.testGameWidget(
      'closes bloc when removed',
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockSparkyBumperCubit();
        whenListen(
          bloc,
          const Stream<SparkyBumperState>.empty(),
          initialState: SparkyBumperState.lit,
        );
        when(bloc.close).thenAnswer((_) async {});
        final sparkyBumper = SparkyBumper.test(bloc: bloc);

        await game.ensureAdd(sparkyBumper);
        await game.ready();
      },
      verify: (game, _) async {
        final sparkyBumper =
            game.descendants().whereType<SparkyBumper>().single;
        game.remove(sparkyBumper);
        game.update(0);
        verify(sparkyBumper.bloc.close).called(1);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'a SparkyBumperBallContactBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final sparkyBumper = SparkyBumper.a();
          await game.ensureAdd(sparkyBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final sparkyBumper =
              game.descendants().whereType<SparkyBumper>().single;
          expect(
            sparkyBumper.children
                .whereType<SparkyBumperBallContactBehavior>()
                .single,
            isNotNull,
          );
        },
      );

      flameTester.testGameWidget(
        'a SparkyBumperBlinkingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final sparkyBumper = SparkyBumper.a();
          await game.ensureAdd(sparkyBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final sparkyBumper =
              game.descendants().whereType<SparkyBumper>().single;
          expect(
            sparkyBumper.children
                .whereType<SparkyBumperBlinkingBehavior>()
                .single,
            isNotNull,
          );
        },
      );
    });

    group("'a' adds", () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          await game.onLoad();
          final component = Component();
          final sparkyBumper = SparkyBumper.a(
            children: [component],
          );
          await game.ensureAdd(sparkyBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final sparkyBumper =
              game.descendants().whereType<SparkyBumper>().single;
          expect(sparkyBumper.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final sparkyBumper = SparkyBumper.a();
          await game.ensureAdd(sparkyBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final sparkyBumper =
              game.descendants().whereType<SparkyBumper>().single;
          expect(
            sparkyBumper.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        },
      );
    });

    group("'b' adds", () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          await game.onLoad();
          final component = Component();
          final sparkyBumper = SparkyBumper.b(
            children: [component],
          );
          await game.ensureAdd(sparkyBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final sparkyBumper =
              game.descendants().whereType<SparkyBumper>().single;
          expect(sparkyBumper.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final sparkyBumper = SparkyBumper.b();
          await game.ensureAdd(sparkyBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final sparkyBumper =
              game.descendants().whereType<SparkyBumper>().single;
          expect(
            sparkyBumper.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        },
      );

      group("'c' adds", () {
        flameTester.testGameWidget(
          'new children',
          setUp: (game, _) async {
            await game.onLoad();
            final component = Component();
            final sparkyBumper = SparkyBumper.c(
              children: [component],
            );
            await game.ensureAdd(sparkyBumper);
            await game.ready();
          },
          verify: (game, _) async {
            final sparkyBumper =
                game.descendants().whereType<SparkyBumper>().single;
            expect(sparkyBumper.children.whereType<Component>(), isNotEmpty);
          },
        );

        flameTester.testGameWidget(
          'a BumpingBehavior',
          setUp: (game, _) async {
            await game.onLoad();
            final sparkyBumper = SparkyBumper.c();
            await game.ensureAdd(sparkyBumper);
            await game.ready();
          },
          verify: (game, _) async {
            final sparkyBumper =
                game.descendants().whereType<SparkyBumper>().single;
            expect(
              sparkyBumper.children.whereType<BumpingBehavior>().single,
              isNotNull,
            );
          },
        );
      });
    });
  });
}
