// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/components/multipliers/behaviors/behaviors.dart';
import 'package:pinball/game/game.dart';

import '../../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MultipliersBehaviors', () {
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
      'calls toggle once per each multiplier when GameBloc emit state',
      setUp: (game, tester) async {
        final behavior = MultipliersBehavior();
        final parent = Multipliers.test();
        final multipliers = [
          MockMultiplier(),
          MockMultiplier(),
          MockMultiplier(),
          MockMultiplier(),
          MockMultiplier(),
        ];
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: GameState.initial(),
        );

        await parent.addAll(multipliers);
        await game.ensureAdd(parent);
        await parent.ensureAdd(behavior);

        await tester.pump();

        for (final multiplier in multipliers) {
          verify(
            () => multiplier.bloc.toggle(1),
          ).called(1);
        }
      },
    );
  });
}
