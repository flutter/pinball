// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';

void main() {
  group('StartGameEvent', () {
    test('StartGame supports value equality', () {
      expect(
        StartGame(),
        equals(StartGame()),
      );
    });

    test('HowToPlay supports value equality', () {
      expect(
        HowToPlay(),
        equals(HowToPlay()),
      );
    });

    test('Play supports value equality', () {
      expect(
        Play(),
        equals(Play()),
      );
    });
  });
}
