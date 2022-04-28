// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/components/multipliers/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.multiplier.x2.lit.keyName,
    Assets.images.multiplier.x2.dimmed.keyName,
    Assets.images.multiplier.x3.lit.keyName,
    Assets.images.multiplier.x3.dimmed.keyName,
    Assets.images.multiplier.x4.lit.keyName,
    Assets.images.multiplier.x4.dimmed.keyName,
    Assets.images.multiplier.x5.lit.keyName,
    Assets.images.multiplier.x5.dimmed.keyName,
    Assets.images.multiplier.x6.lit.keyName,
    Assets.images.multiplier.x6.dimmed.keyName,
  ];

  group('MultipliersBehaviors', () {
    late GameBloc gameBloc;

    setUp(() {
      registerFallbackValue(MockComponent());
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
      assets: assets,
    );

    flameBlocTester.testGameWidget(
      'calls toggle once per each multiplier when GameBloc emit state',
      setUp: (game, tester) async {
        final behavior = MultipliersBehavior();
        final parent = Multipliers.test();
        final multiplier = MockMultiplier();
        final multipliers = [multiplier];

        final streamController = StreamController<GameState>();
        whenListen(
          gameBloc,
          streamController.stream,
          initialState: GameState.initial(),
        );
        when(() => multiplier.addToParent(any()))
            .thenAnswer((_) async => () {});

        await parent.addAll(multipliers);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        await tester.pump();

        streamController.add(GameState.initial().copyWith(score: 100));

        await game.ready();
        await tester.pump();

        for (final multiplier in multipliers) {
          verify(
            () => multiplier.bloc.toggle(any()),
          ).called(1);
        }
      },
    );
  });
}
