// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class _MockRawKeyDownEvent extends Mock implements RawKeyDownEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

class _MockRawKeyUpEvent extends Mock implements RawKeyUpEvent {
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
          flameTester.test(
            'moves upwards when right arrow is pressed',
            (game) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                flipperBloc: flipperBloc,
                side: BoardSide.right,
              );

              final event = _MockRawKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowRight,
              );

              behavior.onKeyEvent(event, {});

              await Future<void>.delayed(Duration.zero);
              verify(flipperBloc.moveUp).called(1);
            },
          );

          flameTester.test(
            'moves downwards when right arrow is released',
            (game) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.right,
                flipperBloc: flipperBloc,
              );

              final event = _MockRawKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowRight,
              );

              behavior.onKeyEvent(event, {});

              await Future<void>.delayed(Duration.zero);
              verify(flipperBloc.moveDown).called(1);
            },
          );

          flameTester.test(
            'moves upwards when D is pressed',
            (game) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.right,
                flipperBloc: flipperBloc,
              );

              final event = _MockRawKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyD,
              );

              behavior.onKeyEvent(event, {});

              await Future<void>.delayed(Duration.zero);
              verify(flipperBloc.moveUp).called(1);
            },
          );

          flameTester.test(
            'moves downwards when D is released',
            (game) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.right,
                flipperBloc: flipperBloc,
              );

              final event = _MockRawKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyD,
              );

              behavior.onKeyEvent(event, {});

              await Future<void>.delayed(Duration.zero);
              verify(flipperBloc.moveDown).called(1);
            },
          );

          group("doesn't move when", () {
            flameTester.test(
              'left arrow is pressed',
              (game) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.right,
                  flipperBloc: flipperBloc,
                );

                final event = _MockRawKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowLeft,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.test(
              'left arrow is released',
              (game) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.right,
                  flipperBloc: flipperBloc,
                );

                final event = _MockRawKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowLeft,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.test(
              'A is pressed',
              (game) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.right,
                  flipperBloc: flipperBloc,
                );

                final event = _MockRawKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyA,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.test(
              'A is released',
              (game) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.right,
                  flipperBloc: flipperBloc,
                );

                final event = _MockRawKeyUpEvent();
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
          flameTester.test(
            'moves upwards when left arrow is pressed',
            (game) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.left,
                flipperBloc: flipperBloc,
              );

              final event = _MockRawKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowLeft,
              );

              behavior.onKeyEvent(event, {});

              await Future<void>.delayed(Duration.zero);
              verify(flipperBloc.moveUp).called(1);
            },
          );

          flameTester.test(
            'moves downwards when left arrow is released',
            (game) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.left,
                flipperBloc: flipperBloc,
              );

              final event = _MockRawKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowLeft,
              );

              behavior.onKeyEvent(event, {});

              await Future<void>.delayed(Duration.zero);
              verify(flipperBloc.moveDown).called(1);
            },
          );

          flameTester.test(
            'moves upwards when A is pressed',
            (game) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.left,
                flipperBloc: flipperBloc,
              );

              final event = _MockRawKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyA,
              );

              behavior.onKeyEvent(event, {});

              await Future<void>.delayed(Duration.zero);
              verify(flipperBloc.moveUp).called(1);
            },
          );

          flameTester.test(
            'moves downwards when A is released',
            (game) async {
              final behavior = FlipperKeyControllingBehavior();
              await game.pump(
                behavior,
                side: BoardSide.left,
                flipperBloc: flipperBloc,
              );

              final event = _MockRawKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyA,
              );

              behavior.onKeyEvent(event, {});

              await Future<void>.delayed(Duration.zero);
              verify(flipperBloc.moveDown).called(1);
            },
          );

          group("doesn't move when", () {
            flameTester.test(
              'right arrow is pressed',
              (game) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.left,
                  flipperBloc: flipperBloc,
                );

                final event = _MockRawKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowRight,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.test(
              'right arrow is released',
              (game) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.left,
                  flipperBloc: flipperBloc,
                );

                final event = _MockRawKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowRight,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.test(
              'D is pressed',
              (game) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.left,
                  flipperBloc: flipperBloc,
                );

                final event = _MockRawKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyD,
                );

                behavior.onKeyEvent(event, {});

                verifyNever(flipperBloc.moveDown);
                verifyNever(flipperBloc.moveUp);
              },
            );

            flameTester.test(
              'D is released',
              (game) async {
                final behavior = FlipperKeyControllingBehavior();
                await game.pump(
                  behavior,
                  side: BoardSide.left,
                  flipperBloc: flipperBloc,
                );

                final event = _MockRawKeyUpEvent();
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
