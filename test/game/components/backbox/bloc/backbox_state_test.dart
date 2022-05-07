// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
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
        expect(
          LeaderboardSuccessState(entries: const []),
          isNotNull,
        );
      });

      test('supports value comparison', () {
        expect(
          LeaderboardSuccessState(entries: const []),
          equals(
            LeaderboardSuccessState(entries: const []),
          ),
        );

        expect(
          LeaderboardSuccessState(entries: const []),
          isNot(
            equals(
              LeaderboardSuccessState(
                entries: const [LeaderboardEntryData.empty],
              ),
            ),
          ),
        );
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
        expect(
          InitialsSuccessState(score: 0),
          isNotNull,
        );
      });

      test('supports value comparison', () {
        expect(
          InitialsSuccessState(score: 0),
          equals(
            InitialsSuccessState(score: 0),
          ),
        );
      });

      group('InitialsFailureState', () {
        test('can be instantiated', () {
          expect(
            InitialsFailureState(
              score: 10,
              character: AndroidTheme(),
            ),
            isNotNull,
          );
        });

        test('supports value comparison', () {
          expect(
            InitialsFailureState(
              score: 10,
              character: AndroidTheme(),
            ),
            equals(
              InitialsFailureState(
                score: 10,
                character: AndroidTheme(),
              ),
            ),
          );
          expect(
            InitialsFailureState(
              score: 10,
              character: AndroidTheme(),
            ),
            isNot(
              equals(
                InitialsFailureState(
                  score: 12,
                  character: AndroidTheme(),
                ),
              ),
            ),
          );
          expect(
            InitialsFailureState(
              score: 10,
              character: AndroidTheme(),
            ),
            isNot(
              equals(
                InitialsFailureState(
                  score: 10,
                  character: DashTheme(),
                ),
              ),
            ),
          );
        });
      });

      group('ShareState', () {
        test('can be instantiated', () {
          expect(
            ShareState(score: 0),
            isNotNull,
          );
        });

        test('supports value comparison', () {
          expect(
            ShareState(score: 0),
            equals(
              ShareState(score: 0),
            ),
          );
        });
      });
    });
  });
}
