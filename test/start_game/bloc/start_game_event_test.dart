// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';

void main() {
  group('StartGameEvent', () {
    test('PlayTapped supports value equality', () {
      expect(
        PlayTapped(),
        equals(PlayTapped()),
      );
    });

    test('CharacterSelected supports value equality', () {
      expect(
        CharacterSelected(),
        equals(CharacterSelected()),
      );
    });

    test('HowToPlayFinished supports value equality', () {
      expect(
        HowToPlayFinished(),
        equals(HowToPlayFinished()),
      );
    });
  });
}
