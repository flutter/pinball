// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/input.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../helpers/helpers.dart';

class _MockGameBloc extends Mock implements GameBloc {}

class _MockGameState extends Mock implements GameState {}

class _MockEventPosition extends Mock implements EventPosition {}

class _MockTapDownDetails extends Mock implements TapDownDetails {}

class _MockTapDownInfo extends Mock implements TapDownInfo {}

class _MockTapUpDetails extends Mock implements TapUpDetails {}

class _MockTapUpInfo extends Mock implements TapUpInfo {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.android.bumper.a.lit.keyName,
    Assets.images.android.bumper.a.dimmed.keyName,
    Assets.images.android.bumper.b.lit.keyName,
    Assets.images.android.bumper.b.dimmed.keyName,
    Assets.images.android.bumper.cow.lit.keyName,
    Assets.images.android.bumper.cow.dimmed.keyName,
    Assets.images.backboard.backboardScores.keyName,
    Assets.images.backboard.backboardGameOver.keyName,
    Assets.images.backboard.display.keyName,
    Assets.images.boardBackground.keyName,
    Assets.images.ball.ball.keyName,
    Assets.images.ball.flameEffect.keyName,
    Assets.images.baseboard.left.keyName,
    Assets.images.baseboard.right.keyName,
    Assets.images.boundary.bottom.keyName,
    Assets.images.boundary.outer.keyName,
    Assets.images.boundary.outerBottom.keyName,
    Assets.images.dino.animatronic.mouth.keyName,
    Assets.images.dino.animatronic.head.keyName,
    Assets.images.dino.topWall.keyName,
    Assets.images.dino.topWallTunnel.keyName,
    Assets.images.dino.bottomWall.keyName,
    Assets.images.dash.animatronic.keyName,
    Assets.images.dash.bumper.a.active.keyName,
    Assets.images.dash.bumper.a.inactive.keyName,
    Assets.images.dash.bumper.b.active.keyName,
    Assets.images.dash.bumper.b.inactive.keyName,
    Assets.images.dash.bumper.main.active.keyName,
    Assets.images.dash.bumper.main.inactive.keyName,
    Assets.images.flipper.left.keyName,
    Assets.images.flipper.right.keyName,
    Assets.images.googleWord.letter1.lit.keyName,
    Assets.images.googleWord.letter1.dimmed.keyName,
    Assets.images.googleWord.letter2.lit.keyName,
    Assets.images.googleWord.letter2.dimmed.keyName,
    Assets.images.googleWord.letter3.lit.keyName,
    Assets.images.googleWord.letter3.dimmed.keyName,
    Assets.images.googleWord.letter4.lit.keyName,
    Assets.images.googleWord.letter4.dimmed.keyName,
    Assets.images.googleWord.letter5.lit.keyName,
    Assets.images.googleWord.letter5.dimmed.keyName,
    Assets.images.googleWord.letter6.lit.keyName,
    Assets.images.googleWord.letter6.dimmed.keyName,
    Assets.images.kicker.left.lit.keyName,
    Assets.images.kicker.left.dimmed.keyName,
    Assets.images.kicker.right.lit.keyName,
    Assets.images.kicker.right.dimmed.keyName,
    Assets.images.launchRamp.ramp.keyName,
    Assets.images.launchRamp.foregroundRailing.keyName,
    Assets.images.launchRamp.backgroundRailing.keyName,
    Assets.images.multiball.lit.keyName,
    Assets.images.multiball.dimmed.keyName,
    Assets.images.multiplier.x2.lit.keyName,
    Assets.images.multiplier.x2.dimmed.keyName,
    Assets.images.multiplier.x3.lit.keyName,
    Assets.images.multiplier.x3.dimmed.keyName,
    Assets.images.multiplier.x4.lit.keyName,
    Assets.images.multiplier.x4.dimmed.keyName,
    Assets.images.multiplier.x5.lit.keyName,
    Assets.images.multiplier.x5.dimmed.keyName,
    Assets.images.multiplier.x6.lit.keyName,
    Assets.images.multiplier.x6.dimmed.keyName,
    Assets.images.plunger.plunger.keyName,
    Assets.images.plunger.rocket.keyName,
    Assets.images.signpost.inactive.keyName,
    Assets.images.signpost.active1.keyName,
    Assets.images.signpost.active2.keyName,
    Assets.images.signpost.active3.keyName,
    Assets.images.slingshot.upper.keyName,
    Assets.images.slingshot.lower.keyName,
    Assets.images.android.spaceship.saucer.keyName,
    Assets.images.android.spaceship.animatronic.keyName,
    Assets.images.android.spaceship.lightBeam.keyName,
    Assets.images.android.ramp.boardOpening.keyName,
    Assets.images.android.ramp.railingForeground.keyName,
    Assets.images.android.ramp.railingBackground.keyName,
    Assets.images.android.ramp.main.keyName,
    Assets.images.android.ramp.arrow.inactive.keyName,
    Assets.images.android.ramp.arrow.active1.keyName,
    Assets.images.android.ramp.arrow.active2.keyName,
    Assets.images.android.ramp.arrow.active3.keyName,
    Assets.images.android.ramp.arrow.active4.keyName,
    Assets.images.android.ramp.arrow.active5.keyName,
    Assets.images.android.rail.main.keyName,
    Assets.images.android.rail.exit.keyName,
    Assets.images.sparky.animatronic.keyName,
    Assets.images.sparky.computer.top.keyName,
    Assets.images.sparky.computer.base.keyName,
    Assets.images.sparky.computer.glow.keyName,
    Assets.images.sparky.animatronic.keyName,
    Assets.images.sparky.bumper.a.lit.keyName,
    Assets.images.sparky.bumper.a.dimmed.keyName,
    Assets.images.sparky.bumper.b.lit.keyName,
    Assets.images.sparky.bumper.b.dimmed.keyName,
    Assets.images.sparky.bumper.c.lit.keyName,
    Assets.images.sparky.bumper.c.dimmed.keyName,
    Assets.images.flapper.flap.keyName,
    Assets.images.flapper.backSupport.keyName,
    Assets.images.flapper.frontSupport.keyName,
  ];

  late GameBloc gameBloc;

  setUp(() {
    gameBloc = _MockGameBloc();
    whenListen(
      gameBloc,
      const Stream<GameState>.empty(),
      initialState: const GameState.initial(),
    );
  });

  final flameTester = FlameTester(
    () => PinballTestGame(assets: assets),
  );
  final debugModeFlameTester = FlameTester(
    () => DebugPinballTestGame(assets: assets),
  );

  final flameBlocTester = FlameBlocTester<PinballGame, GameBloc>(
    gameBuilder: () => PinballTestGame(assets: assets),
    blocBuilder: () => gameBloc,
  );

  group('PinballGame', () {
    group('components', () {
      // TODO(alestiago): tests that Blueprints get added once the Blueprint
      // class is removed.
      flameBlocTester.test(
        'has only one Drain',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<Drain>().length,
            equals(1),
          );
        },
      );

      flameBlocTester.test(
        'has only one BottomGroup',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<BottomGroup>().length,
            equals(1),
          );
        },
      );

      flameBlocTester.test(
        'has only one Launcher',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<Launcher>().length,
            equals(1),
          );
        },
      );

      flameBlocTester.test('has one FlutterForest', (game) async {
        await game.ready();
        expect(
          game.descendants().whereType<FlutterForest>().length,
          equals(1),
        );
      });

      flameBlocTester.test(
        'has only one Multiballs',
        (game) async {
          await game.ready();

          expect(
            game.descendants().whereType<Multiballs>().length,
            equals(1),
          );
        },
      );

      flameBlocTester.test(
        'one GoogleWord',
        (game) async {
          await game.ready();
          expect(
            game.descendants().whereType<GoogleWord>().length,
            equals(1),
          );
        },
      );

      group('controller', () {
        group('listenWhen', () {
          flameTester.testGameWidget(
            'listens when all balls are lost and there are more than 0 rounds',
            setUp: (game, tester) async {
              // TODO(ruimiguel): check why testGameWidget doesn't add any ball
              // to the game. Test needs to have no balls, so fortunately works.
              final newState = _MockGameState();
              when(() => newState.isGameOver).thenReturn(false);
              game.descendants().whereType<ControlledBall>().forEach(
                    (ball) => ball.controller.lost(),
                  );
              await game.ready();

              expect(
                game.controller.listenWhen(_MockGameState(), newState),
                isTrue,
              );
            },
          );

          flameTester.test(
            "doesn't listen when some balls are left",
            (game) async {
              final newState = _MockGameState();
              when(() => newState.isGameOver).thenReturn(false);

              expect(
                game.descendants().whereType<ControlledBall>().length,
                greaterThan(0),
              );
              expect(
                game.controller.listenWhen(_MockGameState(), newState),
                isFalse,
              );
            },
          );

          flameTester.testGameWidget(
            "doesn't listen when game is over",
            setUp: (game, tester) async {
              // TODO(ruimiguel): check why testGameWidget doesn't add any ball
              // to the game. Test needs to have no balls, so fortunately works.
              final newState = _MockGameState();
              when(() => newState.isGameOver).thenReturn(true);
              game.descendants().whereType<ControlledBall>().forEach(
                    (ball) => ball.controller.lost(),
                  );
              await game.ready();

              expect(
                game.descendants().whereType<ControlledBall>().isEmpty,
                isTrue,
              );
              expect(
                game.controller.listenWhen(_MockGameState(), newState),
                isFalse,
              );
            },
          );
        });

        group(
          'onNewState',
          () {
            flameTester.test(
              'spawns a ball',
              (game) async {
                final previousBalls =
                    game.descendants().whereType<ControlledBall>().toList();

                game.controller.onNewState(_MockGameState());
                await game.ready();
                final currentBalls =
                    game.descendants().whereType<ControlledBall>().toList();

                expect(
                  currentBalls.length,
                  equals(previousBalls.length + 1),
                );
              },
            );
          },
        );
      });
    });

    group('flipper control', () {
      flameTester.test('tap down moves left flipper up', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.zero());
        when(() => eventPosition.widget).thenReturn(Vector2.zero());

        final raw = _MockTapDownDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

        final tapDownEvent = _MockTapDownInfo();
        when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapDownEvent.raw).thenReturn(raw);

        final flippers = game.descendants().whereType<Flipper>().where(
              (flipper) => flipper.side == BoardSide.left,
            );

        game.onTapDown(0, tapDownEvent);

        expect(flippers.first.body.linearVelocity.y, isNegative);
      });

      flameTester.test('tap down moves right flipper up', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.zero());
        when(() => eventPosition.widget).thenReturn(game.canvasSize);

        final raw = _MockTapDownDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

        final tapDownEvent = _MockTapDownInfo();
        when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapDownEvent.raw).thenReturn(raw);

        final flippers = game.descendants().whereType<Flipper>().where(
              (flipper) => flipper.side == BoardSide.right,
            );

        game.onTapDown(0, tapDownEvent);

        expect(flippers.first.body.linearVelocity.y, isNegative);
      });

      flameTester.test('tap up moves flipper down', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.zero());
        when(() => eventPosition.widget).thenReturn(Vector2.zero());

        final raw = _MockTapDownDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

        final tapDownEvent = _MockTapDownInfo();
        when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapDownEvent.raw).thenReturn(raw);

        final flippers = game.descendants().whereType<Flipper>().where(
              (flipper) => flipper.side == BoardSide.left,
            );

        game.onTapDown(0, tapDownEvent);

        expect(flippers.first.body.linearVelocity.y, isNegative);

        final tapUpEvent = _MockTapUpInfo();
        when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);

        game.onTapUp(0, tapUpEvent);
        await game.ready();

        expect(flippers.first.body.linearVelocity.y, isPositive);
      });

      flameTester.test('tap cancel moves flipper down', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.zero());
        when(() => eventPosition.widget).thenReturn(Vector2.zero());

        final raw = _MockTapDownDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

        final tapDownEvent = _MockTapDownInfo();
        when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapDownEvent.raw).thenReturn(raw);

        final flippers = game.descendants().whereType<Flipper>().where(
              (flipper) => flipper.side == BoardSide.left,
            );

        game.onTapDown(0, tapDownEvent);

        expect(flippers.first.body.linearVelocity.y, isNegative);

        game.onTapCancel(0);

        expect(flippers.first.body.linearVelocity.y, isPositive);
      });
    });

    group('plunger control', () {
      flameTester.test('tap down moves plunger down', (game) async {
        await game.ready();

        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2(40, 60));

        final raw = _MockTapDownDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.touch);

        final tapDownEvent = _MockTapDownInfo();
        when(() => tapDownEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapDownEvent.raw).thenReturn(raw);

        final plunger = game.descendants().whereType<Plunger>().first;

        game.onTapDown(0, tapDownEvent);

        game.update(1);

        expect(plunger.body.linearVelocity.y, isPositive);
      });
    });
  });

  group('DebugPinballGame', () {
    debugModeFlameTester.test(
      'adds a ball on tap up',
      (game) async {
        final eventPosition = _MockEventPosition();
        when(() => eventPosition.game).thenReturn(Vector2.all(10));

        final raw = _MockTapUpDetails();
        when(() => raw.kind).thenReturn(PointerDeviceKind.mouse);

        final tapUpEvent = _MockTapUpInfo();
        when(() => tapUpEvent.eventPosition).thenReturn(eventPosition);
        when(() => tapUpEvent.raw).thenReturn(raw);

        final previousBalls =
            game.descendants().whereType<ControlledBall>().toList();

        game.onTapUp(0, tapUpEvent);
        await game.ready();

        expect(
          game.descendants().whereType<ControlledBall>().length,
          equals(previousBalls.length + 1),
        );
      },
    );
  });
}
