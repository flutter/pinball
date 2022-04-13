// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';

void main() {
  group('StartGameState', () {
    final testState = StartGameState(
      status: StartGameStatus.selectCharacter,
    );

    test('initial state has correct values', () {
      final state = StartGameState(
        status: StartGameStatus.initial,
      );

      expect(state, StartGameState.initial());
    });

    test('supports value equality', () {
      final secondState = StartGameState(
        status: StartGameStatus.selectCharacter,
      );

      expect(testState, secondState);
    });

    test('supports copyWith', () {
      final secondState = testState.copyWith();

      expect(testState, secondState);
    });

    test('has correct props', () {
      expect(
        testState.props,
        equals([
          StartGameStatus.selectCharacter,
        ]),
      );
    });
  });
}
