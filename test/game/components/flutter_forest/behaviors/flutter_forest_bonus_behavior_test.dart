// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball/game/components/flutter_forest/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.load(theme.Assets.images.dash.ball.keyName);
  }

  Future<void> pump(
    FlutterForest child, {
    required GameBloc gameBloc,
    required SignpostCubit signpostBloc,
    DashBumpersCubit? dashBumpersBloc,
  }) async {
    await ensureAdd(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, GameState>.value(
            value: gameBloc,
          ),
          FlameBlocProvider<SignpostCubit, SignpostState>.value(
            value: signpostBloc,
          ),
          FlameBlocProvider<DashBumpersCubit, DashBumpersState>.value(
            value: dashBumpersBloc ?? DashBumpersCubit(),
          ),
        ],
        children: [
          ZCanvasComponent(
            children: [child],
          ),
        ],
      ),
    );
  }
}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockSignpostCubit extends Mock implements SignpostCubit {}

class _MockDashBumpersCubit extends Mock implements DashBumpersCubit {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FlutterForestBonusBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = _MockGameBloc();
    });

    final flameTester = FlameTester(_TestGame.new);

    test('can be instantiated', () {
      expect(FlutterForestBonusBehavior(), isA<FlutterForestBonusBehavior>());
    });

    flameTester.testGameWidget(
      'adds GameBonus.dashNest to the game '
      'when signpost becomes fully activated',
      setUp: (game, tester) async {
        await game.onLoad();
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final signpostBloc = _MockSignpostCubit();
        final streamController = StreamController<SignpostState>();

        whenListen(
          signpostBloc,
          streamController.stream,
          initialState: SignpostState.inactive,
        );

        await game.pump(
          parent,
          gameBloc: gameBloc,
          signpostBloc: signpostBloc,
        );
        await parent.ensureAdd(behavior);
        await game.ready();

        streamController.add(SignpostState.active3);
        await tester.pump();

        verify(
          () => gameBloc.add(const BonusActivated(GameBonus.dashNest)),
        ).called(1);
      },
    );

    flameTester.testGameWidget(
      'calls onProgressed and onReset '
      'when signpost becomes fully activated',
      setUp: (game, tester) async {
        await game.onLoad();
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final dashBumpersBloc = _MockDashBumpersCubit();
        final signpostBloc = _MockSignpostCubit();
        final streamController = StreamController<SignpostState>();

        whenListen(
          signpostBloc,
          streamController.stream,
          initialState: SignpostState.inactive,
        );

        await game.pump(
          parent,
          gameBloc: gameBloc,
          signpostBloc: signpostBloc,
          dashBumpersBloc: dashBumpersBloc,
        );
        await parent.ensureAdd(behavior);
        await game.ready();

        streamController.add(SignpostState.active3);
        await tester.pump();

        verify(signpostBloc.onProgressed).called(1);
        verify(dashBumpersBloc.onReset).called(1);
      },
    );

    flameTester.testGameWidget(
      'adds BonusBallSpawningBehavior to the game '
      'when signpost becomes fully activated',
      setUp: (game, tester) async {
        await game.onLoad();
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final signpostBloc = _MockSignpostCubit();
        final streamController = StreamController<SignpostState>();

        whenListen(
          signpostBloc,
          streamController.stream,
          initialState: SignpostState.inactive,
        );

        await game.pump(
          parent,
          gameBloc: gameBloc,
          signpostBloc: signpostBloc,
        );
        await parent.ensureAdd(behavior);
        streamController.add(SignpostState.active3);
        await game.ready();
        await tester.pump();

        expect(
          game.descendants().whereType<BonusBallSpawningBehavior>().length,
          equals(1),
        );
      },
    );
  });
}
