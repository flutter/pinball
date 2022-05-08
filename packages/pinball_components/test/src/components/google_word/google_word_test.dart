// ignore_for_file: cascade_invocations

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      Assets.images.googleWord.letter1.lit.keyName,
      Assets.images.googleWord.letter1.dimmed.keyName,
      Assets.images.googleWord.letter2.lit.keyName,
      Assets.images.googleWord.letter2.dimmed.keyName,
      Assets.images.googleWord.letter3.lit.keyName,
      Assets.images.googleWord.letter3.dimmed.keyName,
      Assets.images.googleWord.letter4.lit.keyName,
      Assets.images.googleWord.letter4.dimmed.keyName,
      Assets.images.googleWord.letter5.lit.keyName,
      Assets.images.googleWord.letter5.dimmed.keyName,
      Assets.images.googleWord.letter6.lit.keyName,
      Assets.images.googleWord.letter6.dimmed.keyName,
    ]);
  }

  Future<void> pump(GoogleWord child) async {
    await ensureAdd(
      FlameBlocProvider<GoogleWordCubit, GoogleWordState>.value(
        value: GoogleWordCubit(),
        children: [child],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  group('GoogleWord', () {
    test('can be instantiated', () {
      expect(GoogleWord(position: Vector2.zero()), isA<GoogleWord>());
    });

    flameTester.test(
      'loads letters correctly',
      (game) async {
        final googleWord = GoogleWord(position: Vector2.zero());
        await game.pump(googleWord);

        expect(
          googleWord.children.whereType<GoogleLetter>().length,
          equals(6),
        );
      },
    );
  });
}
