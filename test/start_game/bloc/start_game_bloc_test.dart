import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';

import '../../helpers/helpers.dart';

void main() {
  late PinballGame pinballGame;

  setUp(() {
    pinballGame = MockPinballGame();

    when(
      () => pinballGame.gameFlowController,
    ).thenReturn(
      MockGameFlowController(),
    );
  });

  group('StartGameBloc', () {
    blocTest<StartGameBloc, StartGameState>(
      'on StartGame changes status to StartGame',
      build: () => StartGameBloc(
        game: pinballGame,
      ),
      act: (bloc) => bloc.add(const StartGame()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.startGame,
        )
      ],
    );

    blocTest<StartGameBloc, StartGameState>(
      'on HowToPlay changes status to howToPlay',
      build: () => StartGameBloc(
        game: pinballGame,
      ),
      act: (bloc) => bloc.add(const HowToPlay()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.howToPlay,
        )
      ],
    );

    blocTest<StartGameBloc, StartGameState>(
      'on Play changes status to play',
      build: () => StartGameBloc(
        game: pinballGame,
      ),
      act: (bloc) => bloc.add(const Play()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.play,
        )
      ],
    );
  });
}
