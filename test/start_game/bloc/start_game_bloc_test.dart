import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';

void main() {
  group('StartGameBloc', () {
    blocTest<StartGameBloc, StartGameState>(
      'on PlayTapped changes status to selectCharacter',
      build: StartGameBloc.new,
      act: (bloc) => bloc.add(const PlayTapped()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.selectCharacter,
        )
      ],
    );

    blocTest<StartGameBloc, StartGameState>(
      'on CharacterSelected changes status to howToPlay',
      build: StartGameBloc.new,
      act: (bloc) => bloc.add(const CharacterSelected()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.howToPlay,
        )
      ],
    );

    blocTest<StartGameBloc, StartGameState>(
      'on HowToPlayFinished changes status to play',
      build: StartGameBloc.new,
      act: (bloc) => bloc.add(const HowToPlayFinished()),
      expect: () => [
        const StartGameState(
          status: StartGameStatus.play,
        )
      ],
    );
  });
}
