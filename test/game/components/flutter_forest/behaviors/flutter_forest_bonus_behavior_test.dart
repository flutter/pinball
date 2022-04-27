// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/flutter_forest/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('FlutterForestBonusBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = MockGameBloc();
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
    );

    flameBlocTester.testGameWidget(
      'adds GameBonus.dashNest to the game when all bumpers are active',
      setUp: (game, tester) async {
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final bumpers = [
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
        ];
        await parent.addAll(bumpers);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        for (final bumper in bumpers) {
          bumper.bloc.onBallContacted();
        }
        await tester.pump();

        verify(
          () => gameBloc.add(const BonusActivated(GameBonus.dashNest)),
        ).called(1);
      },
    );

    flameBlocTester.testGameWidget(
      'adds a new ball to the game when all bumpers are active',
      setUp: (game, tester) async {
        final behavior = FlutterForestBonusBehavior();
        final parent = FlutterForest.test();
        final bumpers = [
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
          DashNestBumper.test(bloc: DashNestBumperCubit()),
        ];
        await parent.addAll(bumpers);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        for (final bumper in bumpers) {
          bumper.bloc.onBallContacted();
        }
        await game.ready();

        expect(
          game.descendants().whereType<Ball>().single,
          isNotNull,
        );
      },
    );
  });
}
