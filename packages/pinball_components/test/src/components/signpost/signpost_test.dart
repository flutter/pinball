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
    await ensureAdd(
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

    flameTester.test(
      'can be added',
      (game) async {
        final signpost = Signpost();
        await game.pump(signpost);
        expect(game.descendants().contains(signpost), isTrue);
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

          game.camera.followVector2(Vector2.zero());
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

          game.camera.followVector2(Vector2.zero());
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

          game.camera.followVector2(Vector2.zero());
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

          game.camera.followVector2(Vector2.zero());
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
            for (var id in DashBumperId.values) id: DashBumperSpriteState.active
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

    flameTester.test(
      'onNewState calls onProgressed and onReset',
      (game) async {
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

        game
            .descendants()
            .whereType<FlameBlocListener<DashBumpersCubit, DashBumpersState>>()
            .single
            .onNewState(DashBumpersState.initial());

        verify(signpostBloc.onProgressed).called(1);
        verify(dashBumpersBloc.onReset).called(1);
      },
    );

    flameTester.test('adds new children', (game) async {
      final component = Component();
      final signpost = Signpost(
        children: [component],
      );
      await game.pump(signpost);
      expect(signpost.children, contains(component));
    });
  });
}
