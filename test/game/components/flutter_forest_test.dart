// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballTestGame.new);

  group('FlutterForest', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final flutterForest = FlutterForest();
        await game.ensureAdd(flutterForest);

        expect(game.contains(flutterForest), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'a FlutterSignPost',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.descendants().whereType<FlutterSignPost>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a DashAnimatronic',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.firstChild<DashAnimatronic>(),
            isNotNull,
          );
        },
      );

      flameTester.test(
        'a BigDashNestBumper',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.descendants().whereType<BigDashNestBumper>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'two SmallDashNestBumper',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.descendants().whereType<SmallDashNestBumper>().length,
            equals(2),
          );
        },
      );
    });

    group('bumpers', () {
      late Ball ball;
      late GameBloc gameBloc;

      setUp(() {
        ball = Ball(baseColor: const Color(0xFF00FFFF));
      });

      final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
        gameBuilder: EmptyPinballTestGame.new,
        blocBuilder: () {
          gameBloc = MockGameBloc();
          const state = GameState.initial();
          whenListen(gameBloc, Stream.value(state), initialState: state);
          return gameBloc;
        },
      );

      flameBlocTester.testGameWidget(
        'add Scored event',
        setUp: (game, tester) async {
          final flutterForest = FlutterForest();
          await game.ensureAddAll([
            flutterForest,
            ball,
          ]);
          game.addContactCallback(BallScorePointsCallback(game));

          final bumpers = flutterForest.descendants().whereType<ScorePoints>();

          for (final bumper in bumpers) {
            beginContact(game, bumper, ball);
            verify(
              () => gameBloc.add(
                Scored(points: bumper.points),
              ),
            ).called(1);
          }
        },
      );

      flameBlocTester.testGameWidget(
        'adds GameBonus.dashNest to the game when all bumpers are activated',
        setUp: (game, _) async {
          final ball = Ball(baseColor: const Color(0xFFFF0000));
          final flutterForest = FlutterForest();
          await game.ensureAddAll([flutterForest, ball]);

          final bumpers = flutterForest.children.whereType<DashNestBumper>();
          expect(bumpers, isNotEmpty);
          for (final bumper in bumpers) {
            beginContact(game, bumper, ball);
            await game.ready();

            if (bumper == bumpers.last) {
              verify(
                () => gameBloc.add(const BonusActivated(GameBonus.dashNest)),
              ).called(1);
            } else {
              verifyNever(
                () => gameBloc.add(const BonusActivated(GameBonus.dashNest)),
              );
            }
          }
        },
      );
    });
  });
}
