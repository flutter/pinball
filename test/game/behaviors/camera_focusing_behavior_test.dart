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

      flameTester.test('loads', (game) async {
        late final behavior = CameraFocusingBehavior();
        await game.ensureAdd(
          FlameBlocProvider<GameBloc, GameState>.value(
            value: GameBloc(),
            children: [behavior],
          ),
        );
        expect(game.descendants(), contains(behavior));
      });

      flameTester.test('resizes and snaps', (game) async {
        final behavior = CameraFocusingBehavior();
        await game.ensureAdd(
          FlameBlocProvider<GameBloc, GameState>.value(
            value: GameBloc(),
            children: [behavior],
          ),
        );

        behavior.onGameResize(Vector2.all(10));
        expect(game.camera.zoom, greaterThan(0));
      });

      flameTester.test(
        'changes focus when loaded',
        (game) async {
          final behavior = CameraFocusingBehavior();
          final previousZoom = game.camera.zoom;
          expect(game.camera.follow, isNull);

          await game.ensureAdd(
            FlameBlocProvider<GameBloc, GameState>.value(
              value: GameBloc(),
              children: [behavior],
            ),
          );

          expect(game.camera.follow, isNotNull);
          expect(game.camera.zoom, isNot(equals(previousZoom)));
        },
      );

      flameTester.test(
        'listenWhen only listens when status changes',
        (game) async {
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
        flameTester.test(
          'zooms when started playing',
          (game) async {
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
            final previousPosition = game.camera.position.clone();
            await game.ready();

            final zoom = behavior.children.whereType<CameraZoom>().single;
            game.update(zoom.controller.duration!);
            game.update(0);

            expect(zoom.controller.completed, isTrue);
            expect(
              game.camera.position,
              isNot(equals(previousPosition)),
            );
          },
        );

        flameTester.test(
          'zooms when game is over',
          (game) async {
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
            final previousPosition = game.camera.position.clone();
            await game.ready();

            final zoom = behavior.children.whereType<CameraZoom>().single;
            game.update(zoom.controller.duration!);
            game.update(0);

            expect(zoom.controller.completed, isTrue);
            expect(
              game.camera.position,
              isNot(equals(previousPosition)),
            );
          },
        );
      });
    },
  );
}
