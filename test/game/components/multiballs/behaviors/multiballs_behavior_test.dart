// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/multiballs/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiball.lit.keyName,
    Assets.images.multiball.dimmed.keyName,
  ];

  group('MultiballsBehavior', () {
    late GameBloc gameBloc;

    setUp(() {
      gameBloc = MockGameBloc();
    });

    final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
      gameBuilder: EmptyPinballTestGame.new,
      blocBuilder: () => gameBloc,
      assets: assets,
    );

    flameBlocTester.testGameWidget(
      'animate multiballs when new GameBonus.dashNest received',
      setUp: (game, tester) async {
        final streamController = StreamController<GameState>();
        whenListen(
          gameBloc,
          streamController.stream,
          initialState: const GameState.initial(),
        );

        final behavior = MultiballsBehavior();
        final parent = Multiballs.test();
        final multiballs = [
          Multiball.test(bloc: MockMultiballCubit()),
          Multiball.test(bloc: MockMultiballCubit()),
          Multiball.test(bloc: MockMultiballCubit()),
          Multiball.test(bloc: MockMultiballCubit()),
        ];

        await parent.addAll(multiballs);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        streamController.add(
          GameState.initial().copyWith(bonusHistory: [GameBonus.dashNest]),
        );
        await tester.pump();

        for (final multiball in multiballs) {
          verify(multiball.bloc.onAnimate).called(1);
        }
      },
    );

    flameBlocTester.testGameWidget(
      "don't animate multiballs when now new GameBonus.dashNest received",
      setUp: (game, tester) async {
        final streamController = StreamController<GameState>();
        whenListen(
          gameBloc,
          streamController.stream,
          initialState: const GameState.initial(),
        );

        final behavior = MultiballsBehavior();
        final parent = Multiballs.test();
        final multiballs = [
          Multiball.test(bloc: MockMultiballCubit()),
          Multiball.test(bloc: MockMultiballCubit()),
          Multiball.test(bloc: MockMultiballCubit()),
          Multiball.test(bloc: MockMultiballCubit()),
        ];

        await parent.addAll(multiballs);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        streamController.add(
          GameState.initial().copyWith(
            bonusHistory: [GameBonus.sparkyTurboCharge],
          ),
        );
        await tester.pump();

        for (final multiball in multiballs) {
          verifyNever(multiball.bloc.onAnimate);
        }
      },
    );
  });
}
