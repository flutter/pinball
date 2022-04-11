// ignore_for_file: cascade_invocations

import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  group('Google Letter', () {
    flameTester.test(
      'first loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.first);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      'second loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.second);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      'third loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.third);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      'fourth loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.fourth);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      'fifth loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.fifth);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    group('activate', () {
      flameTester.test('returns normally', (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.first);
        await game.ensureAdd(googleLetter);
        await expectLater(googleLetter.activate, returnsNormally);
      });

      flameTester.test('adds an Effect', (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.first);
        await game.ensureAdd(googleLetter);
        await googleLetter.activate();
        await game.ready();

        expect(
          googleLetter.descendants().whereType<Effect>().length,
          equals(1),
        );
      });
    });

    group('deactivate', () {
      flameTester.test('returns normally', (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.first);
        await game.ensureAdd(googleLetter);
        await expectLater(googleLetter.deactivate, returnsNormally);
      });

      flameTester.test('adds an Effect', (game) async {
        final googleLetter = GoogleLetter(GoogleLetterOrder.first);
        await game.ensureAdd(googleLetter);
        await googleLetter.activate();
        await game.ready();

        expect(
          googleLetter.descendants().whereType<Effect>().length,
          equals(1),
        );
      });
    });
  });
}
