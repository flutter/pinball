// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('FlutterForest', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final flutterForest = FlutterForest(position: Vector2(0, 0));
        await game.ensureAdd(flutterForest);

        expect(game.contains(flutterForest), isTrue);
      },
    );

    flameTester.test(
      'onNewState adds a new ball',
      (game) async {
        final flutterForest = FlutterForest(position: Vector2(0, 0));
        await game.ready();
        await game.ensureAdd(flutterForest);

        final previousBalls = game.descendants().whereType<Ball>().length;
        flutterForest.onNewState(MockGameState());
        await game.ready();

        expect(
          game.descendants().whereType<Ball>().length,
          greaterThan(previousBalls),
        );
      },
    );

    group('listenWhen', () {
      final gameBloc = MockGameBloc();
      final tester = flameBlocTester(gameBloc: () => gameBloc);

      setUp(() {
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      tester.widgetTest(
        'listens when a Bonus.dashNest is added',
        (game, tester) async {
          await game.ready();
          final flutterForest =
              game.descendants().whereType<FlutterForest>().first;

          const state = GameState(
            score: 0,
            balls: 3,
            activatedBonusLetters: [],
            activatedDashNests: {},
            bonusHistory: [GameBonus.dashNest],
          );

          expect(
            flutterForest.listenWhen(const GameState.initial(), state),
            isTrue,
          );
        },
      );
    });
  });

  group('DashNestBumperBallContactCallback', () {
    final gameBloc = MockGameBloc();
    final tester = flameBlocTester(gameBloc: () => gameBloc);

    setUp(() {
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    tester.widgetTest(
      'adds a DashNestActivated event with DashNestBumper.id',
      (game, tester) async {
        final contactCallback = DashNestBumperBallContactCallback();
        const id = '0';
        final dashNestBumper = MockDashNestBumper();
        when(() => dashNestBumper.id).thenReturn(id);
        when(() => dashNestBumper.gameRef).thenReturn(game);

        contactCallback.begin(dashNestBumper, MockBall(), MockContact());

        verify(() => gameBloc.add(DashNestActivated(dashNestBumper.id)))
            .called(1);
      },
    );
  });

  group('BigDashNestBumper', () {
    test('has points', () {
      final dashNestBumper = BigDashNestBumper(id: '');
      expect(dashNestBumper.points, greaterThan(0));
    });
  });

  group('SmallDashNestBumper', () {
    test('has points', () {
      final dashNestBumper = SmallDashNestBumper(id: '');
      expect(dashNestBumper.points, greaterThan(0));
    });
  });
}
