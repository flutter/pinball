// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.signpost.inactive.keyName,
      Assets.images.signpost.active1.keyName,
      Assets.images.signpost.active2.keyName,
      Assets.images.signpost.active3.keyName,
    ]);
  }

  Future<void> pump(
    Signpost child, {
    SignpostCubit? signpostBloc,
    DashBumpersCubit? dashBumpersBloc,
  }) async {
    await onLoad();
    await world.ensureAdd(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<SignpostCubit, SignpostState>.value(
            value: signpostBloc ?? SignpostCubit(),
          ),
          FlameBlocProvider<DashBumpersCubit, DashBumpersState>.value(
            value: dashBumpersBloc ?? DashBumpersCubit(),
          ),
        ],
        children: [child],
      ),
    );
  }
}

class _MockSignpostCubit extends Mock implements SignpostCubit {}

class _MockDashBumpersCubit extends Mock implements DashBumpersCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('Signpost', () {
    const goldenPath = '../golden/signpost/';

    test('can be instantiated', () {
      expect(Signpost(), isA<Signpost>());
    });

    flameTester.testGameWidget(
      'can be added',
      setUp: (game, _) async {
        final signpost = Signpost();
        await game.pump(signpost);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<Signpost>().length,
          equals(1),
        );
      },
    );

    group('renders correctly', () {
      flameTester.testGameWidget(
        'inactive sprite',
        setUp: (game, tester) async {
          final signpost = Signpost();
          await game.pump(signpost);
          await tester.pump();

          expect(
            signpost.firstChild<SpriteGroupComponent>()!.current,
            equals(SignpostState.inactive),
          );

          game.camera.moveTo(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenPath}inactive.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active1 sprite',
        setUp: (game, tester) async {
          final signpost = Signpost();
          final bloc = SignpostCubit();
          await game.pump(signpost, signpostBloc: bloc);
          bloc.onProgressed();
          await tester.pump();

          expect(
            signpost.firstChild<SpriteGroupComponent>()!.current,
            equals(SignpostState.active1),
          );

          game.camera.moveTo(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenPath}active1.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active2 sprite',
        setUp: (game, tester) async {
          final signpost = Signpost();
          final bloc = SignpostCubit();
          await game.pump(signpost, signpostBloc: bloc);
          bloc
            ..onProgressed()
            ..onProgressed();
          await tester.pump();

          expect(
            signpost.firstChild<SpriteGroupComponent>()!.current,
            equals(SignpostState.active2),
          );

          game.camera.moveTo(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenPath}active2.png'),
          );
        },
      );

      flameTester.testGameWidget(
        'active3 sprite',
        setUp: (game, tester) async {
          final signpost = Signpost();
          final bloc = SignpostCubit();
          await game.pump(signpost, signpostBloc: bloc);
          bloc
            ..onProgressed()
            ..onProgressed()
            ..onProgressed();
          await tester.pump();

          expect(
            signpost.firstChild<SpriteGroupComponent>()!.current,
            equals(SignpostState.active3),
          );

          game.camera.moveTo(Vector2.zero());
        },
        verify: (game, tester) async {
          await expectLater(
            find.byGame<_TestGame>(),
            matchesGoldenFile('${goldenPath}active3.png'),
          );
        },
      );
    });

    flameTester.testGameWidget(
      'listenWhen is true when all dash bumpers are activated',
      setUp: (game, tester) async {
        final activatedBumpersState = DashBumpersState(
          bumperSpriteStates: {
            for (final id in DashBumperId.values)
              id: DashBumperSpriteState.active,
          },
        );
        final signpost = Signpost();
        final dashBumpersBloc = _MockDashBumpersCubit();
        whenListen(
          dashBumpersBloc,
          const Stream<DashBumpersState>.empty(),
          initialState: DashBumpersState.initial(),
        );
        await game.pump(signpost, dashBumpersBloc: dashBumpersBloc);

        final signpostListener = game
            .descendants()
            .whereType<FlameBlocListener<DashBumpersCubit, DashBumpersState>>()
            .single;
        final listenWhen = signpostListener.listenWhen(
          DashBumpersState.initial(),
          activatedBumpersState,
        );

        expect(listenWhen, isTrue);
      },
    );

    flameTester.testGameWidget(
      'onNewState calls onProgressed and onReset',
      setUp: (game, _) async {
        final signpost = Signpost();
        final signpostBloc = _MockSignpostCubit();
        whenListen(
          signpostBloc,
          const Stream<SignpostState>.empty(),
          initialState: SignpostState.inactive,
        );
        final dashBumpersBloc = _MockDashBumpersCubit();
        whenListen(
          dashBumpersBloc,
          const Stream<DashBumpersState>.empty(),
          initialState: DashBumpersState.initial(),
        );
        await game.pump(
          signpost,
          signpostBloc: signpostBloc,
          dashBumpersBloc: dashBumpersBloc,
        );
      },
      verify: (game, _) async {
        final signpostBloc = game
            .descendants()
            .whereType<FlameBlocProvider<SignpostCubit, SignpostState>>()
            .single
            .bloc;
        final dashBumpersBloc = game
            .descendants()
            .whereType<FlameBlocProvider<DashBumpersCubit, DashBumpersState>>()
            .single
            .bloc;
        game
            .descendants()
            .whereType<FlameBlocListener<DashBumpersCubit, DashBumpersState>>()
            .single
            .onNewState(DashBumpersState.initial());

        verify(signpostBloc.onProgressed).called(1);
        verify(dashBumpersBloc.onReset).called(1);
      },
    );

    flameTester.testGameWidget(
      'adds new children',
      setUp: (game, _) async {
        final component = Component();
        final signpost = Signpost(
          children: [component],
        );
        await game.pump(signpost);
      },
      verify: (game, _) async {
        final signpost = game.descendants().whereType<Signpost>().single;
        expect(signpost.children.whereType<Component>(), isNotEmpty);
      },
    );
  });
}
