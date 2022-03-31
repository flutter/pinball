// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('BonusWord', () {
    flameTester.test(
      'loads the letters correctly',
      (game) async {
        await game.ready();

        final bonusWord = game.children.whereType<BonusWord>().first;
        final letters = bonusWord.children.whereType<BonusLetter>();
        expect(letters.length, equals(GameBloc.bonusWord.length));
      },
    );

    group('listenWhen', () {
      final previousState = MockGameState();
      final currentState = MockGameState();

      test(
        'returns true when there is a new word bonus awarded',
        () {
          when(() => previousState.bonusHistory).thenReturn([]);
          when(() => currentState.bonusHistory).thenReturn([GameBonus.word]);

          expect(
            BonusWord(position: Vector2.zero()).listenWhen(
              previousState,
              currentState,
            ),
            isTrue,
          );
        },
      );

      test(
        'returns false when there is no new word bonus awarded',
        () {
          when(() => previousState.bonusHistory).thenReturn([GameBonus.word]);
          when(() => currentState.bonusHistory).thenReturn([GameBonus.word]);

          expect(
            BonusWord(position: Vector2.zero()).listenWhen(
              previousState,
              currentState,
            ),
            isFalse,
          );
        },
      );
    });

    group('onNewState', () {
      final state = MockGameState();
      flameTester.test(
        'adds sequence effect to the letters when the player receives a bonus',
        (game) async {
          when(() => state.bonusHistory).thenReturn([GameBonus.word]);

          final bonusWord = BonusWord(position: Vector2.zero());
          await game.ensureAdd(bonusWord);
          await game.ready();

          bonusWord.onNewState(state);
          game.update(0); // Run one frame so the effects are added

          final letters = bonusWord.children.whereType<BonusLetter>();
          expect(letters.length, equals(GameBloc.bonusWord.length));

          for (final letter in letters) {
            expect(
              letter.children.whereType<SequenceEffect>().length,
              equals(1),
            );
          }
        },
      );

      flameTester.test(
        'adds a color effect to reset the color when the sequence is finished',
        (game) async {
          when(() => state.bonusHistory).thenReturn([GameBonus.word]);

          final bonusWord = BonusWord(position: Vector2.zero());
          await game.ensureAdd(bonusWord);
          await game.ready();

          bonusWord.onNewState(state);
          // Run the amount of time necessary for the animation to finish
          game.update(3);
          game.update(0); // Run one additional frame so the effects are added

          final letters = bonusWord.children.whereType<BonusLetter>();
          expect(letters.length, equals(GameBloc.bonusWord.length));

          for (final letter in letters) {
            expect(
              letter.children.whereType<ColorEffect>().length,
              equals(1),
            );
          }
        },
      );
    });
  });

  group('BonusLetter', () {
    final flameTester = FlameTester(PinballGameTest.create);

    flameTester.test(
      'loads correctly',
      (game) async {
        final bonusLetter = BonusLetter(
          letter: 'G',
          index: 0,
        );
        await game.ensureAdd(bonusLetter);
        await game.ready();

        expect(game.contains(bonusLetter), isTrue);
      },
    );

    group('body', () {
      flameTester.test(
        'is static',
        (game) async {
          final bonusLetter = BonusLetter(
            letter: 'G',
            index: 0,
          );
          await game.ensureAdd(bonusLetter);

          expect(bonusLetter.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final bonusLetter = BonusLetter(
            letter: 'G',
            index: 0,
          );
          await game.ensureAdd(bonusLetter);

          expect(bonusLetter.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'is sensor',
        (game) async {
          final bonusLetter = BonusLetter(
            letter: 'G',
            index: 0,
          );
          await game.ensureAdd(bonusLetter);

          final fixture = bonusLetter.body.fixtures[0];
          expect(fixture.isSensor, isTrue);
        },
      );

      flameTester.test(
        'shape is circular',
        (game) async {
          final bonusLetter = BonusLetter(
            letter: 'G',
            index: 0,
          );
          await game.ensureAdd(bonusLetter);

          final fixture = bonusLetter.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(1.85));
        },
      );
    });

    group('bonus letter activation', () {
      late GameBloc gameBloc;
      final tester = flameBlocTester(gameBloc: () => gameBloc);

      setUp(() {
        gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      tester.testGameWidget(
        'adds BonusLetterActivated to GameBloc when not activated',
        setUp: (game, tester) async {
          await game.ready();
          final bonusLetter = game.descendants().whereType<BonusLetter>().first;
          bonusLetter.activate();
          await game.ready();

          await tester.pump();
        },
        verify: (game, tester) async {
          verify(() => gameBloc.add(const BonusLetterActivated(0))).called(1);
        },
      );

      tester.testGameWidget(
        "doesn't add BonusLetterActivated to GameBloc when already activated",
        setUp: (game, tester) async {
          const state = GameState(
            score: 0,
            balls: 2,
            activatedBonusLetters: [0],
            activatedDashNests: {},
            bonusHistory: [],
          );
          whenListen(
            gameBloc,
            Stream.value(state),
            initialState: state,
          );

          await game.ready();
          final bonusLetter = game.descendants().whereType<BonusLetter>().first;
          bonusLetter.activate();
          await game.ready();
        },
        verify: (game, tester) async {
          verifyNever(() => gameBloc.add(const BonusLetterActivated(0)));
        },
      );

      tester.testGameWidget(
        'adds a ColorEffect',
        setUp: (game, tester) async {
          const state = GameState(
            score: 0,
            balls: 2,
            activatedBonusLetters: [0],
            activatedDashNests: {},
            bonusHistory: [],
          );

          await game.ready();
          final bonusLetter = game.descendants().whereType<BonusLetter>().first;
          bonusLetter.activate();

          bonusLetter.onNewState(state);
          await tester.pump();
        },
        verify: (game, tester) async {
          final bonusLetter = game.descendants().whereType<BonusLetter>().first;
          expect(
            bonusLetter.children.whereType<ColorEffect>().length,
            equals(1),
          );
        },
      );

      tester.testGameWidget(
        'only listens when there is a change on the letter status',
        setUp: (game, tester) async {
          await game.ready();
          final bonusLetter = game.descendants().whereType<BonusLetter>().first;
          bonusLetter.activate();
        },
        verify: (game, tester) async {
          const state = GameState(
            score: 0,
            balls: 2,
            activatedBonusLetters: [0],
            activatedDashNests: {},
            bonusHistory: [],
          );
          final bonusLetter = game.descendants().whereType<BonusLetter>().first;
          expect(
            bonusLetter.listenWhen(const GameState.initial(), state),
            isTrue,
          );
        },
      );
    });

    group('BonusLetterBallContactCallback', () {
      test('calls ball.activate', () {
        final ball = MockBall();
        final bonusLetter = MockBonusLetter();
        final contactCallback = BonusLetterBallContactCallback();

        when(() => bonusLetter.isEnabled).thenReturn(true);

        contactCallback.begin(ball, bonusLetter, MockContact());

        verify(bonusLetter.activate).called(1);
      });

      test("doesn't call ball.activate when letter is disabled", () {
        final ball = MockBall();
        final bonusLetter = MockBonusLetter();
        final contactCallback = BonusLetterBallContactCallback();

        when(() => bonusLetter.isEnabled).thenReturn(false);

        contactCallback.begin(ball, bonusLetter, MockContact());

        verifyNever(bonusLetter.activate);
      });
    });
  });
}
