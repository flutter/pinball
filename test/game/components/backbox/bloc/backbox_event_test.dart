// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/backbox/bloc/backbox_bloc.dart';
import 'package:pinball_theme/pinball_theme.dart';

void main() {
  group('BackboxEvent', () {
    group('PlayerInitialsRequested', () {
      test('can be instantiated', () {
        expect(
          PlayerInitialsRequested(score: 0, character: AndroidTheme()),
          isNotNull,
        );
      });

      test('supports value comparison', () {
        expect(
          PlayerInitialsRequested(score: 0, character: AndroidTheme()),
          equals(
            PlayerInitialsRequested(score: 0, character: AndroidTheme()),
          ),
        );

        expect(
          PlayerInitialsRequested(score: 0, character: AndroidTheme()),
          isNot(
            equals(
              PlayerInitialsRequested(score: 1, character: AndroidTheme()),
            ),
          ),
        );

        expect(
          PlayerInitialsRequested(score: 0, character: AndroidTheme()),
          isNot(
            equals(
              PlayerInitialsRequested(score: 0, character: SparkyTheme()),
            ),
          ),
        );
      });
    });

    group('PlayerInitialsSubmitted', () {
      test('can be instantiated', () {
        expect(
          PlayerInitialsSubmitted(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          isNotNull,
        );
      });

      test('supports value comparison', () {
        expect(
          PlayerInitialsSubmitted(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          equals(
            PlayerInitialsSubmitted(
              score: 0,
              initials: 'AAA',
              character: AndroidTheme(),
            ),
          ),
        );

        expect(
          PlayerInitialsSubmitted(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          isNot(
            equals(
              PlayerInitialsSubmitted(
                score: 1,
                initials: 'AAA',
                character: AndroidTheme(),
              ),
            ),
          ),
        );

        expect(
          PlayerInitialsSubmitted(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          isNot(
            equals(
              PlayerInitialsSubmitted(
                score: 0,
                initials: 'AAA',
                character: SparkyTheme(),
              ),
            ),
          ),
        );

        expect(
          PlayerInitialsSubmitted(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          isNot(
            equals(
              PlayerInitialsSubmitted(
                score: 0,
                initials: 'BBB',
                character: AndroidTheme(),
              ),
            ),
          ),
        );
      });
    });

    group('LeaderboardRequested', () {
      test('can be instantiated', () {
        expect(LeaderboardRequested(), isNotNull);
      });

      test('supports value comparison', () {
        expect(LeaderboardRequested(), equals(LeaderboardRequested()));
      });
    });
  });
}
