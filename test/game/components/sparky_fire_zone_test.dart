// ignore_for_file: cascade_invocations

import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(EmptyPinballTestGame.new);

  group('SparkyFireZone', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final sparkyFireZone = SparkyFireZone();
        await game.ensureAdd(sparkyFireZone);

        expect(game.contains(sparkyFireZone), isTrue);
      },
    );

    group('loads', () {
      flameTester.test(
        'three SparkyBumper',
        (game) async {
          await game.ready();
          final sparkyFireZone = SparkyFireZone();
          await game.ensureAdd(sparkyFireZone);

          expect(
            sparkyFireZone.descendants().whereType<SparkyBumper>().length,
            equals(3),
          );
        },
      );
    });

    group('bumpers', () {
      late ControlledSparkyBumper controlledSparkyBumper;
      late Ball ball;
      late GameBloc gameBloc;

      setUp(() {
        ball = Ball(baseColor: const Color(0xFF00FFFF));
        gameBloc = MockGameBloc();
        whenListen(
          gameBloc,
          const Stream<GameState>.empty(),
          initialState: const GameState.initial(),
        );
      });

      final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
        gameBuilder: EmptyPinballTestGame.new,
        blocBuilder: () => gameBloc,
      );

      flameTester.testGameWidget(
        'activate when deactivated bumper is hit',
        setUp: (game, tester) async {
          controlledSparkyBumper = ControlledSparkyBumper.a();
          await game.ensureAdd(controlledSparkyBumper);

          controlledSparkyBumper.controller.hit();
        },
        verify: (game, tester) async {
          expect(controlledSparkyBumper.controller.isActivated, isTrue);
        },
      );

      flameTester.testGameWidget(
        'deactivate when activated bumper is hit',
        setUp: (game, tester) async {
          controlledSparkyBumper = ControlledSparkyBumper.a();
          await game.ensureAdd(controlledSparkyBumper);

          controlledSparkyBumper.controller.hit();
          controlledSparkyBumper.controller.hit();
        },
        verify: (game, tester) async {
          expect(controlledSparkyBumper.controller.isActivated, isFalse);
        },
      );

      flameBlocTester.testGameWidget(
        'add Scored event',
        setUp: (game, tester) async {
          final sparkyFireZone = SparkyFireZone();
          await game.ensureAdd(sparkyFireZone);
          await game.ensureAdd(ball);
          game.addContactCallback(BallScorePointsCallback(game));

          final bumpers = sparkyFireZone.descendants().whereType<ScorePoints>();

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
    });
  });
}
