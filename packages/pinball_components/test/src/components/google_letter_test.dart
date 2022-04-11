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
      '0th loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(0);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '1st loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(1);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '2nd loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(2);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '3d loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(3);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '4th loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(4);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    flameTester.test(
      '5th loads correctly',
      (game) async {
        final googleLetter = GoogleLetter(5);
        await game.ready();
        await game.ensureAdd(googleLetter);

        expect(game.contains(googleLetter), isTrue);
      },
    );

    test('throws error when index out of range', () {
      expect(() => GoogleLetter(-1), throwsA(isA<RangeError>()));
      expect(() => GoogleLetter(6), throwsA(isA<RangeError>()));
    });

    group('activate', () {
      flameTester.test('returns normally', (game) async {
        final googleLetter = GoogleLetter(0);
        await game.ensureAdd(googleLetter);
        await expectLater(googleLetter.activate, returnsNormally);
      });

      flameTester.test('adds an Effect', (game) async {
        final googleLetter = GoogleLetter(0);
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
        final googleLetter = GoogleLetter(0);
        await game.ensureAdd(googleLetter);
        await expectLater(googleLetter.deactivate, returnsNormally);
      });

      flameTester.test('adds an Effect', (game) async {
        final googleLetter = GoogleLetter(0);
        await game.ensureAdd(googleLetter);
        await googleLetter.deactivate();
        await game.ready();

        expect(
          googleLetter.descendants().whereType<Effect>().length,
          equals(1),
        );
      });
    });
  });
}
