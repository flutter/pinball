import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';

class _MockPinballGame extends Mock implements PinballGame {}

class _MockGameFlowController extends Mock implements GameFlowController {}

void main() {
  late PinballGame pinballGame;

  setUp(() {
    pinballGame = _MockPinballGame();

    when(
      () => pinballGame.gameFlowController,
    ).thenReturn(
      _MockGameFlowController(),
    );
  });

  group('StartGameBloc', () {
    blocTest<StartGameBloc, StartGameState>(
      'on PlayTapped changes status to selectCharacter',
      build: () => StartGameBloc(
        game: pinballGame,
      ),
      act: (bloc) => bloc.add(const PlayTapped()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.selectCharacter,
        )
      ],
    );

    blocTest<StartGameBloc, StartGameState>(
      'on CharacterSelected changes status to howToPlay',
      build: () => StartGameBloc(
        game: pinballGame,
      ),
      act: (bloc) => bloc.add(const CharacterSelected()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.howToPlay,
        )
      ],
    );

    blocTest<StartGameBloc, StartGameState>(
      'on HowToPlayFinished changes status to play',
      build: () => StartGameBloc(
        game: pinballGame,
      ),
      act: (bloc) => bloc.add(const HowToPlayFinished()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.play,
        )
      ],
    );
  });
}
