import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballTestGame.new);

  group('GoogleWord', () {
    flameTester.test(
      'loads the letters correctly',
      (game) async {
        const word = 'Google';
        final googleWord = GoogleWord(position: Vector2.zero());
        await game.ensureAdd(googleWord);

        final letters = googleWord.children.whereType<GoogleLetter>();
        expect(letters.length, equals(word.length));
      },
    );
  });
}
