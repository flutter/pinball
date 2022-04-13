// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/bloc/start_game_bloc.dart';

void main() {
  group('StartGameEvent', () {
    test('SelectCharacter supports value equality', () {
      expect(
        SelectCharacter(),
        equals(SelectCharacter()),
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
