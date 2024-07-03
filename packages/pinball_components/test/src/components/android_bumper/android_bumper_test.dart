// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/android_bumper/behaviors/behaviors.dart';
import 'package:pinball_components/src/components/bumping_behavior.dart';

import '../../../helpers/helpers.dart';

class _MockAndroidBumperCubit extends Mock implements AndroidBumperCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.android.bumper.a.lit.keyName,
    Assets.images.android.bumper.a.dimmed.keyName,
    Assets.images.android.bumper.b.lit.keyName,
    Assets.images.android.bumper.b.dimmed.keyName,
    Assets.images.android.bumper.cow.lit.keyName,
    Assets.images.android.bumper.cow.dimmed.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('AndroidBumper', () {
    flameTester.testGameWidget(
      '"a" loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final androidBumper = AndroidBumper.a();
        await game.ensureAdd(androidBumper);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<AndroidBumper>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      '"b" loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final androidBumper = AndroidBumper.b();
        await game.ensureAdd(androidBumper);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<AndroidBumper>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      '"cow" loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final androidBumper = AndroidBumper.cow();
        await game.ensureAdd(androidBumper);
        await game.ready();
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<AndroidBumper>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'closes bloc when removed',
      setUp: (game, _) async {
        await game.onLoad();
        final bloc = _MockAndroidBumperCubit();
        whenListen(
          bloc,
          const Stream<AndroidBumperState>.empty(),
          initialState: AndroidBumperState.lit,
        );
        when(bloc.close).thenAnswer((_) async {});
        final androidBumper = AndroidBumper.test(bloc: bloc);

        await game.ensureAdd(androidBumper);
        await game.ready();
      },
      verify: (game, _) async {
        final androidBumper =
            game.descendants().whereType<AndroidBumper>().single;
        final bloc = androidBumper.bloc;
        game.remove(androidBumper);
        game.update(0);
        expect(game.descendants().whereType<AndroidBumper>(), isEmpty);
        verify(bloc.close).called(1);
      },
    );

    group('adds', () {
      flameTester.testGameWidget(
        'an AndroidBumperBallContactBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final androidBumper = AndroidBumper.a();
          await game.ensureAdd(androidBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final androidBumper =
              game.descendants().whereType<AndroidBumper>().single;
          expect(
            androidBumper.children
                .whereType<AndroidBumperBallContactBehavior>(),
            isNotEmpty,
          );
        },
      );

      flameTester.testGameWidget(
        'an AndroidBumperBlinkingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final androidBumper = AndroidBumper.a();
          await game.ensureAdd(androidBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final androidBumper =
              game.descendants().whereType<AndroidBumper>().single;
          expect(
            androidBumper.children
                .whereType<AndroidBumperBlinkingBehavior>()
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
          final androidBumper = AndroidBumper.a(
            children: [component],
          );
          await game.ensureAdd(androidBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final androidBumper =
              game.descendants().whereType<AndroidBumper>().single;
          expect(androidBumper.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final androidBumper = AndroidBumper.a();
          await game.ensureAdd(androidBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final androidBumper =
              game.descendants().whereType<AndroidBumper>().single;
          expect(
            androidBumper.children.whereType<BumpingBehavior>().single,
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
          final androidBumper = AndroidBumper.b(
            children: [component],
          );
          await game.ensureAdd(androidBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final androidBumper =
              game.descendants().whereType<AndroidBumper>().single;
          expect(androidBumper.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final androidBumper = AndroidBumper.b();
          await game.ensureAdd(androidBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final androidBumper =
              game.descendants().whereType<AndroidBumper>().single;
          expect(
            androidBumper.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        },
      );
    });

    group("'cow' adds", () {
      flameTester.testGameWidget(
        'new children',
        setUp: (game, _) async {
          await game.onLoad();
          final component = Component();
          final androidBumper = AndroidBumper.cow(
            children: [component],
          );
          await game.ensureAdd(androidBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final androidBumper =
              game.descendants().whereType<AndroidBumper>().single;
          expect(androidBumper.children.whereType<Component>(), isNotEmpty);
        },
      );

      flameTester.testGameWidget(
        'a BumpingBehavior',
        setUp: (game, _) async {
          await game.onLoad();
          final androidBumper = AndroidBumper.cow();
          await game.ensureAdd(androidBumper);
          await game.ready();
        },
        verify: (game, _) async {
          final androidBumper =
              game.descendants().whereType<AndroidBumper>().single;
          expect(
            androidBumper.children.whereType<BumpingBehavior>().single,
            isNotNull,
          );
        },
      );
    });
  });
}
