// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/google_letter/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

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

    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = MockGoogleLetterCubit();
      whenListen(
        bloc,
        const Stream<GoogleLetterState>.empty(),
        initialState: GoogleLetterState.active,
      );
      when(bloc.close).thenAnswer((_) async {});
      final googleLetter = GoogleLetter.test(bloc: bloc);

      await game.ensureAdd(googleLetter);
      game.remove(googleLetter);
      await game.ready();

      verify(bloc.close).called(1);
    });

    flameTester.test('adds a GoogleLetterBallContactBehavior', (game) async {
      final googleLetter = GoogleLetter(0);
      await game.ensureAdd(googleLetter);
      expect(
        googleLetter.children
            .whereType<GoogleLetterBallContactBehavior>()
            .single,
        isNotNull,
      );
    });
  });
}
