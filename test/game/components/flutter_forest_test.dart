// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
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
        final flutterForest = FlutterForest();
        await game.ensureAdd(flutterForest);

        expect(game.contains(flutterForest), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'a FlutterSignPost',
        (game) async {
          await game.ready();

          expect(
            game.descendants().whereType<FlutterSignPost>().length,
            equals(1),
          );
        },
      );
    });

    flameTester.test(
      'onNewState adds a new ball',
      (game) async {
        final flutterForest = FlutterForest();
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
      final tester = flameBlocTester(
        game: TestGame.new,
        gameBloc: () => gameBloc,
      );

      setUp(() {
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      tester.testGameWidget(
        'listens when a Bonus.dashNest is added',
        verify: (game, tester) async {
          final flutterForest = FlutterForest();

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
    final tester = flameBlocTester(
      // TODO(alestiago): Use TestGame.new once a controller is implemented.
      game: PinballGameTest.create,
      gameBloc: () => gameBloc,
    );

    setUp(() {
      whenListen(
        gameBloc,
        const Stream<GameState>.empty(),
        initialState: const GameState.initial(),
      );
    });

    final dashNestBumper = MockDashNestBumper();
    tester.testGameWidget(
      'adds a DashNestActivated event with DashNestBumper.id',
      setUp: (game, tester) async {
        const id = '0';
        when(() => dashNestBumper.id).thenReturn(id);
        when(() => dashNestBumper.gameRef).thenReturn(game);
      },
      verify: (game, tester) async {
        final contactCallback = DashNestBumperBallContactCallback();
        contactCallback.begin(dashNestBumper, MockBall(), MockContact());

        verify(
          () => gameBloc.add(DashNestActivated(dashNestBumper.id)),
        ).called(1);
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
