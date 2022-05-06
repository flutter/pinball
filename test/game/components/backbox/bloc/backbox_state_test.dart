// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/backbox/bloc/backbox_bloc.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('BackboxState', () {
    group('LoadingState', () {
      test('can be instantiated', () {
        expect(LoadingState(), isNotNull);
      });

      test('supports value comparison', () {
        expect(LoadingState(), equals(LoadingState()));
      });
    });

    group('LeaderboardSuccessState', () {
      test('can be instantiated', () {
        expect(LeaderboardSuccessState(), isNotNull);
      });

      test('supports value comparison', () {
        expect(LeaderboardSuccessState(), equals(LeaderboardSuccessState()));
      });
    });

    group('LeaderboardFailureState', () {
      test('can be instantiated', () {
        expect(LeaderboardFailureState(), isNotNull);
      });

      test('supports value comparison', () {
        expect(LeaderboardFailureState(), equals(LeaderboardFailureState()));
      });
    });

    group('InitialsFormState', () {
      test('can be instantiated', () {
        expect(
          InitialsFormState(
            score: 0,
            character: AndroidTheme(),
          ),
          isNotNull,
        );
      });

      test('supports value comparison', () {
        expect(
          InitialsFormState(
            score: 0,
            character: AndroidTheme(),
          ),
          equals(
            InitialsFormState(
              score: 0,
              character: AndroidTheme(),
            ),
          ),
        );

        expect(
          InitialsFormState(
            score: 0,
            character: AndroidTheme(),
          ),
          isNot(
            equals(
              InitialsFormState(
                score: 1,
                character: AndroidTheme(),
              ),
            ),
          ),
        );

        expect(
          InitialsFormState(
            score: 0,
            character: AndroidTheme(),
          ),
          isNot(
            equals(
              InitialsFormState(
                score: 0,
                character: SparkyTheme(),
              ),
            ),
          ),
        );
      });
    });

    group('InitialsSuccessState', () {
      test('can be instantiated', () {
        expect(InitialsSuccessState(), isNotNull);
      });

      test('supports value comparison', () {
        expect(InitialsSuccessState(), equals(InitialsSuccessState()));
      });

      group('InitialsFailureState', () {
        test('can be instantiated', () {
          expect(InitialsFailureState(), isNotNull);
        });

        test('supports value comparison', () {
          expect(InitialsFailureState(), equals(InitialsFailureState()));
        });
      });
    });
  });
}
