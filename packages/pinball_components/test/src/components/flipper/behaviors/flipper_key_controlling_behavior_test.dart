// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

class _TestGame extends Forge2DGame {
  Future<void> pump(
    FlipperKeyControllingBehavior behavior, {
    required BoardSide side,
    FlipperCubit? flipperBloc,
  }) async {
    final flipper = Flipper.test(side: side);
    await ensureAdd(flipper);
    await flipper.ensureAdd(
      FlameBlocProvider<FlipperCubit, FlipperState>.value(
        value: flipperBloc ?? FlipperCubit(),
        children: [behavior],
      ),
    );
  }
}

class _MockFlipperCubit extends Mock implements FlipperCubit {}

class _MockKeyDownEvent extends Mock implements KeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockKeyUpEvent extends Mock implements KeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FlipperKeyControllingBehavior', () {
    final flameTester = FlameTester(_TestGame.new);

    group(
      'onKeyEvent',
      () {
        late FlipperCubit flipperBloc;

        setUp(() {
          flipperBloc = _MockFlipperCubit();
          whenListen<FlipperState>(
            flipperBloc,
            const Stream.empty(),
            initialState: FlipperState.movingDown,
          );
        });

        group('on right Flipper', () {
          flameTester.testGameWidget(
            'moves upwards when right arrow is pressed',
            setUp: (game, _) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                flipperBloc: flipperBloc,
                side: BoardSide.right,
              );
            },
            verify: (game, _) async {
              final behavior = game
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .single;
              final event = _MockKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowRight,
              );

              behavior.onKeyEvent(event, {});

              game.update(0);
              verify(flipperBloc.moveUp).called(1);
            },
          );

          flameTester.testGameWidget(
            'moves downwards when right arrow is released',
            setUp: (game, _) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.right,
                flipperBloc: flipperBloc,
              );
            },
            verify: (game, _) async {
              final behavior = game
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .single;

              final event = _MockKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowRight,
              );

              behavior.onKeyEvent(event, {});

              game.update(0);
              verify(flipperBloc.moveDown).called(1);
            },
          );

          flameTester.testGameWidget(
            'moves upwards when D is pressed',
            setUp: (game, _) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.right,
                flipperBloc: flipperBloc,
              );
            },
            verify: (game, _) async {
              final behavior = game
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .single;

              final event = _MockKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyD,
              );

              behavior.onKeyEvent(event, {});

              game.update(0);
              verify(flipperBloc.moveUp).called(1);
            },
          );

          flameTester.testGameWidget(
            'moves downwards when D is released',
            setUp: (game, _) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.right,
                flipperBloc: flipperBloc,
              );
            },
            verify: (game, _) async {
              final behavior = game
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .single;

              final event = _MockKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyD,
              );

              behavior.onKeyEvent(event, {});

              game.update(0);
              verify(flipperBloc.moveDown).called(1);
            },
          );

          group("doesn't move when", () {
            flameTester.testGameWidget(
              'left arrow is pressed',
              setUp: (game, _) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.right,
                  flipperBloc: flipperBloc,
                );
              },
              verify: (game, _) async {
                final behavior = game
                    .descendants()
                    .whereType<FlipperKeyControllingBehavior>()
                    .single;

                final event = _MockKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowLeft,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.testGameWidget(
              'left arrow is released',
              setUp: (game, _) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.right,
                  flipperBloc: flipperBloc,
                );
              },
              verify: (game, _) async {
                final behavior = game
                    .descendants()
                    .whereType<FlipperKeyControllingBehavior>()
                    .single;
                final event = _MockKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowLeft,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.testGameWidget(
              'A is pressed',
              setUp: (game, _) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.right,
                  flipperBloc: flipperBloc,
                );
              },
              verify: (game, _) async {
                final behavior = game
                    .descendants()
                    .whereType<FlipperKeyControllingBehavior>()
                    .single;
                final event = _MockKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyA,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.testGameWidget(
              'A is released',
              setUp: (game, _) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.right,
                  flipperBloc: flipperBloc,
                );
              },
              verify: (game, _) async {
                final behavior = game
                    .descendants()
                    .whereType<FlipperKeyControllingBehavior>()
                    .single;

                final event = _MockKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyA,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );
          });
        });

        group('on left Flipper', () {
          flameTester.testGameWidget(
            'moves upwards when left arrow is pressed',
            setUp: (game, _) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.left,
                flipperBloc: flipperBloc,
              );
            },
            verify: (game, _) async {
              final behavior = game
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .single;
              final event = _MockKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowLeft,
              );

              behavior.onKeyEvent(event, {});

              game.update(0);
              verify(flipperBloc.moveUp).called(1);
            },
          );

          flameTester.testGameWidget(
            'moves downwards when left arrow is released',
            setUp: (game, _) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.left,
                flipperBloc: flipperBloc,
              );
            },
            verify: (game, _) async {
              final behavior = game
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .single;
              final event = _MockKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowLeft,
              );

              behavior.onKeyEvent(event, {});

              game.update(0);
              verify(flipperBloc.moveDown).called(1);
            },
          );

          flameTester.testGameWidget(
            'moves upwards when A is pressed',
            setUp: (game, _) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.left,
                flipperBloc: flipperBloc,
              );
            },
            verify: (game, _) async {
              final behavior = game
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .single;

              final event = _MockKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyA,
              );

              behavior.onKeyEvent(event, {});

              game.update(0);
              verify(flipperBloc.moveUp).called(1);
            },
          );

          flameTester.testGameWidget(
            'moves downwards when A is released',
            setUp: (game, _) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.left,
                flipperBloc: flipperBloc,
              );
            },
            verify: (game, _) async {
              final behavior = game
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .single;

              final event = _MockKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyA,
              );

              behavior.onKeyEvent(event, {});

              game.update(0);
              verify(flipperBloc.moveDown).called(1);
            },
          );

          group("doesn't move when", () {
            flameTester.testGameWidget(
              'right arrow is pressed',
              setUp: (game, _) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.left,
                  flipperBloc: flipperBloc,
                );
              },
              verify: (game, _) async {
                final behavior = game
                    .descendants()
                    .whereType<FlipperKeyControllingBehavior>()
                    .single;

                final event = _MockKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowRight,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.testGameWidget(
              'right arrow is released',
              setUp: (game, _) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.left,
                  flipperBloc: flipperBloc,
                );
              },
              verify: (game, _) async {
                final behavior = game
                    .descendants()
                    .whereType<FlipperKeyControllingBehavior>()
                    .single;

                final event = _MockKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowRight,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.testGameWidget(
              'D is pressed',
              setUp: (game, _) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.left,
                  flipperBloc: flipperBloc,
                );
              },
              verify: (game, _) async {
                final behavior = game
                    .descendants()
                    .whereType<FlipperKeyControllingBehavior>()
                    .single;
                final event = _MockKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyD,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.testGameWidget(
              'D is released',
              setUp: (game, _) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.left,
                  flipperBloc: flipperBloc,
                );
              },
              verify: (game, _) async {
                final behavior = game
                    .descendants()
                    .whereType<FlipperKeyControllingBehavior>()
                    .single;

                final event = _MockKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyD,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );
          });
        });
      },
    );
  });
}
