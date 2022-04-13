import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/bloc/start_game_bloc.dart';
import 'package:pinball/game/game.dart';

class MockPinballGame extends Mock implements PinballGame {}

class MockGameFlowController extends Mock implements GameFlowController {}

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
      'on SelectCharacter changes status to selectCharacter',
      build: () => StartGameBloc(
        game: pinballGame,
      ),
      act: (bloc) => bloc.add(const SelectCharacter()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.selectCharacter,
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
