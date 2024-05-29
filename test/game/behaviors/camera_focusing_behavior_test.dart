// ignore_for_file: cascade_invocations

import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/behaviors/camera_focusing_behavior.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group(
    'CameraFocusingBehavior',
    () {
      final flameTester = FlameTester(FlameGame.new);

      test('can be instantiated', () {
        expect(
          CameraFocusingBehavior(),
          isA<CameraFocusingBehavior>(),
        );
      });

      flameTester.testGameWidget(
        'loads',
        setUp: (game, _) async {
          late final behavior = CameraFocusingBehavior();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [behavior],
            ),
          );
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<CameraFocusingBehavior>(),
            isNotEmpty,
          );
        },
      );

      flameTester.testGameWidget(
        'resizes and snaps',
        setUp: (game, _) async {
          final behavior = CameraFocusingBehavior();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [behavior],
            ),
          );
        },
        verify: (game, _) async {
          game
              .descendants()
              .whereType<CameraFocusingBehavior>()
              .single
              .onGameResize(Vector2.all(10));
          expect(game.camera.viewfinder.zoom, greaterThan(0));
        },
      );

      flameTester.testGameWidget(
        'changes focus when loaded',
        setUp: (game, _) async {
          expect(game.camera.viewfinder.zoom, equals(1));
          final behavior = CameraFocusingBehavior();
          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [behavior],
            ),
          );
        },
        verify: (game, tester) async {
          final behavior =
              game.descendants().whereType<CameraFocusingBehavior>().single;

          await behavior.onLoad();

          expect(game.camera.viewfinder.zoom, isNot(equals(1)));
        },
      );

      flameTester.testGameWidget(
        'listenWhen only listens when status changes',
        verify: (game, _) async {
          final behavior = CameraFocusingBehavior();
          const waiting = GameState.initial();
          final playing =
              const GameState.initial().copyWith(status: GameStatus.playing);
          final gameOver =
              const GameState.initial().copyWith(status: GameStatus.gameOver);

          expect(behavior.listenWhen(waiting, waiting), isFalse);
          expect(behavior.listenWhen(waiting, playing), isTrue);
          expect(behavior.listenWhen(waiting, gameOver), isTrue);

          expect(behavior.listenWhen(playing, playing), isFalse);
          expect(behavior.listenWhen(playing, waiting), isTrue);
          expect(behavior.listenWhen(playing, gameOver), isTrue);

          expect(behavior.listenWhen(gameOver, gameOver), isFalse);
          expect(behavior.listenWhen(gameOver, waiting), isTrue);
          expect(behavior.listenWhen(gameOver, playing), isTrue);
        },
      );

      group('onNewState', () {
        flameTester.testGameWidget(
          'zooms when started playing',
          setUp: (game, _) async {
            final playing =
                const GameState.initial().copyWith(status: GameStatus.playing);

            final behavior = CameraFocusingBehavior();
            await game.ensureAdd(
              FlameBlocProvider<GameBloc, GameState>.value(
                value: GameBloc(),
                children: [behavior],
              ),
            );
            behavior.onNewState(playing);
          },
          verify: (game, _) async {
            final previousPosition = Vector2(-23, -45);
            game.camera.viewfinder.position = previousPosition;
            final behavior =
                game.descendants().whereType<CameraFocusingBehavior>().single;
            game.update(0);
            final zoom = behavior.children.whereType<CameraZoom>().single;
            game.update(zoom.controller.duration!);
            game.update(0);

            expect(zoom.controller.completed, isTrue);
            expect(
              game.camera.viewfinder.position,
              isNot(equals(previousPosition)),
            );
          },
        );

        flameTester.testGameWidget(
          'zooms when game is over',
          setUp: (game, _) async {
            final playing = const GameState.initial().copyWith(
              status: GameStatus.gameOver,
            );

            final behavior = CameraFocusingBehavior();
            await game.ensureAdd(
              FlameBlocProvider<GameBloc, GameState>.value(
                value: GameBloc(),
                children: [behavior],
              ),
            );

            behavior.onNewState(playing);
          },
          verify: (game, _) async {
            final previousPosition = Vector2(-23, -45);
            final behavior =
                game.descendants().whereType<CameraFocusingBehavior>().single;
            game.update(0);
            final zoom = behavior.children.whereType<CameraZoom>().single;
            game.update(zoom.controller.duration!);
            game.update(0);

            expect(zoom.controller.completed, isTrue);
            expect(
              game.camera.viewfinder.position,
              isNot(equals(previousPosition)),
            );
          },
        );
      });
    },
  );
}
