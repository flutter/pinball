// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballGameTest.new);

  group('GoogleWord', () {
    const googleWord = 'Google';

    flameTester.test(
      'loads the letters correctly',
      (game) async {
        final bonusWord = GoogleWord(
          position: Vector2.zero(),
        );
        await game.ensureAdd(bonusWord);

        final letters = bonusWord.children.whereType<GoogleLetter>();
        expect(letters.length, equals(googleWord.length));

        for (var index = 0; index < googleWord.length; index++) {
          expect(letters.elementAt(index).index, equals(index));
        }
      },
    );
  });
}
