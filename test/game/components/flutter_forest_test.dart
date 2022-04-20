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
  final assets = [
    Assets.images.dash.bumper.main.active.keyName,
    Assets.images.dash.bumper.main.inactive.keyName,
    Assets.images.dash.bumper.a.active.keyName,
    Assets.images.dash.bumper.a.inactive.keyName,
    Assets.images.dash.bumper.b.active.keyName,
    Assets.images.dash.bumper.b.inactive.keyName,
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
  ];
  final flameTester = FlameTester(() => EmptyPinballTestGame(assets));

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
        'a Signpost',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.descendants().whereType<Signpost>().length,
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
        'three DashNestBumper',
        (game) async {
          final flutterForest = FlutterForest();
          await game.ensureAdd(flutterForest);

          expect(
            flutterForest.descendants().whereType<DashNestBumper>().length,
            equals(3),
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
        gameBuilder: () => EmptyPinballTestGame(assets),
        blocBuilder: () {
          gameBloc = MockGameBloc();
          const state = GameState.initial();
          whenListen(gameBloc, Stream.value(state), initialState: state);
          return gameBloc;
        },
        assets: assets,
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
        'adds GameBonus.dashNest to the game when 3 bumpers are activated',
        setUp: (game, _) async {
          final ball = Ball(baseColor: const Color(0xFFFF0000));
          final flutterForest = FlutterForest();
          await game.ensureAddAll([flutterForest, ball]);

          final bumpers = flutterForest.children.whereType<DashNestBumper>();
          expect(bumpers.length, equals(3));
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

      flameBlocTester.testGameWidget(
        'deactivates bumpers when 3 are active',
        setUp: (game, _) async {
          final ball = Ball(baseColor: const Color(0xFFFF0000));
          final flutterForest = FlutterForest();
          await game.ensureAddAll([flutterForest, ball]);

          final bumpers = [
            MockDashNestBumper(),
            MockDashNestBumper(),
            MockDashNestBumper(),
          ];

          for (final bumper in bumpers) {
            flutterForest.controller.activateBumper(bumper);
            await game.ready();

            if (bumper == bumpers.last) {
              for (final bumper in bumpers) {
                verify(bumper.deactivate).called(1);
              }
            }
          }
        },
      );
    });
  });
}
