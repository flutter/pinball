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

  group('BonusLetter', () {
    final flameTester = FlameTester(PinballGameTest.create);

    flameTester.test(
      'loads correctly',
      (game) async {
        final bonusLetter = BonusLetter(
          position: Vector2.zero(),
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
        'positions correctly',
        (game) async {
          final position = Vector2.all(10);
          final bonusLetter = BonusLetter(
            position: position,
            letter: 'G',
            index: 0,
          );
          await game.ensureAdd(bonusLetter);
          game.contains(bonusLetter);

          expect(bonusLetter.body.position, position);
        },
      );

      flameTester.test(
        'is static',
        (game) async {
          final bonusLetter = BonusLetter(
            position: Vector2.zero(),
            letter: 'G',
            index: 0,
          );
          await game.ensureAdd(bonusLetter);

          expect(bonusLetter.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('first fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final bonusLetter = BonusLetter(
            position: Vector2.zero(),
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
            position: Vector2.zero(),
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
            position: Vector2.zero(),
            letter: 'G',
            index: 0,
          );
          await game.ensureAdd(bonusLetter);

          final fixture = bonusLetter.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(2));
        },
      );
    });

    group('bonus letter activation', () {
      final gameBloc = MockGameBloc();

      setUp(() {
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      final tester = flameBlocTester(gameBloc: gameBloc);

      tester.widgetTest(
        'adds BonusLetterActivated to GameBloc when not activated',
        (game, tester) async {
          await game.ready();

          game.children.whereType<BonusLetter>().first.activate();
          await tester.pump();

          verify(() => gameBloc.add(const BonusLetterActivated(0))).called(1);
        },
      );

      tester.widgetTest(
        "doesn't add BonusLetterActivated to GameBloc when already activated",
        (game, tester) async {
          const state = GameState(
            score: 0,
            balls: 2,
            activatedBonusLetters: [0],
            bonusHistory: [],
          );
          whenListen(
            gameBloc,
            Stream.value(state),
            initialState: state,
          );
          await game.ready();

          game.children.whereType<BonusLetter>().first.activate();
          await game.ready(); // Making sure that all additions are done

          verifyNever(() => gameBloc.add(const BonusLetterActivated(0)));
        },
      );

      tester.widgetTest(
        'adds a ColorEffect',
        (game, tester) async {
          await game.ready();
          await tester.pump();

          const state = GameState(
            score: 0,
            balls: 2,
            activatedBonusLetters: [0],
            bonusHistory: [],
          );

          final bonusLetter = game.children.whereType<BonusLetter>().first;

          bonusLetter.onNewState(state);
          await tester.pump();

          expect(
            bonusLetter.children.whereType<ColorEffect>().length,
            equals(1),
          );
        },
      );

      tester.widgetTest(
        'only listens when there is a change on the letter status',
        (game, tester) async {
          await game.ready();
          await tester.pump();

          const state = GameState(
            score: 0,
            balls: 2,
            activatedBonusLetters: [0],
            bonusHistory: [],
          );

          final bonusLetter = game.children.whereType<BonusLetter>().first;

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
        contactCallback.begin(ball, bonusLetter, MockContact());

        verify(bonusLetter.activate).called(1);
      });
    });
  });
}
