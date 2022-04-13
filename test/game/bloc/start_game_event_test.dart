import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/bloc/start_game_bloc.dart';

void main() {
  group('StartGameEvent', () {
    test('SelectCharacter supports value equality', () {
      expect(
        const SelectCharacter(),
        equals(const SelectCharacter()),
      );
    });

    test('HowToPlay supports value equality', () {
      expect(
        const HowToPlay(),
        equals(const HowToPlay()),
      );
    });

    test('Play supports value equality', () {
      expect(
        const Play(),
        equals(const Play()),
      );
    });
  });
}
