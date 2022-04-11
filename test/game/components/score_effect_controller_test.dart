// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScoreEffectController', () {
    late ScoreEffectController controller;
    late PinballGame game;

    setUpAll(() {
      registerFallbackValue(Component());
    });

    setUp(() {
      game = MockPinballGame();
      when(() => game.add(any())).thenAnswer((_) async {});

      controller = ScoreEffectController(game);
    });

    group('listenWhen', () {
      test('returns true when the user has earned points', () {
        const previous = GameState.initial();
        const current = GameState(
          score: 10,
          balls: 3,
          activatedBonusLetters: [],
          bonusHistory: [],
          activatedDashNests: {},
        );
        expect(controller.listenWhen(previous, current), isTrue);
      });

      test(
        'returns true when the user has earned points and there was no '
        'previous state',
        () {
          const current = GameState(
            score: 10,
            balls: 3,
            activatedBonusLetters: [],
            bonusHistory: [],
            activatedDashNests: {},
          );
          expect(controller.listenWhen(null, current), isTrue);
        },
      );

      test(
        'returns false when no points were earned',
        () {
          const current = GameState.initial();
          const previous = GameState.initial();
          expect(controller.listenWhen(previous, current), isFalse);
        },
      );
    });

    group('onNewState', () {
      test(
        'adds a ScoreText with the correct score for the '
        'first time',
        () {
          const state = GameState(
            score: 10,
            balls: 3,
            activatedBonusLetters: [],
            bonusHistory: [],
            activatedDashNests: {},
          );

          controller.onNewState(state);

          final effect =
              verify(() => game.add(captureAny())).captured.first as ScoreText;

          expect(effect.text, equals('10'));
        },
      );

      test('adds a ScoreTextEffect with the correct score', () {
        controller.onNewState(
          const GameState(
            score: 10,
            balls: 3,
            activatedBonusLetters: [],
            bonusHistory: [],
            activatedDashNests: {},
          ),
        );

        controller.onNewState(
          const GameState(
            score: 14,
            balls: 3,
            activatedBonusLetters: [],
            bonusHistory: [],
            activatedDashNests: {},
          ),
        );

        final effect =
            verify(() => game.add(captureAny())).captured.last as ScoreText;

        expect(effect.text, equals('4'));
      });
    });
  });
}
