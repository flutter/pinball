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

    group('PlayerInitialsSubmited', () {
      test('can be instantiated', () {
        expect(
          PlayerInitialsSubmited(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          isNotNull,
        );
      });

      test('supports value comparison', () {
        expect(
          PlayerInitialsSubmited(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          equals(
            PlayerInitialsSubmited(
              score: 0,
              initials: 'AAA',
              character: AndroidTheme(),
            ),
          ),
        );

        expect(
          PlayerInitialsSubmited(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          isNot(
            equals(
              PlayerInitialsSubmited(
                score: 1,
                initials: 'AAA',
                character: AndroidTheme(),
              ),
            ),
          ),
        );

        expect(
          PlayerInitialsSubmited(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          isNot(
            equals(
              PlayerInitialsSubmited(
                score: 0,
                initials: 'AAA',
                character: SparkyTheme(),
              ),
            ),
          ),
        );

        expect(
          PlayerInitialsSubmited(
            score: 0,
            initials: 'AAA',
            character: AndroidTheme(),
          ),
          isNot(
            equals(
              PlayerInitialsSubmited(
                score: 0,
                initials: 'BBB',
                character: AndroidTheme(),
              ),
            ),
          ),
        );
      });
    });
  });
}
