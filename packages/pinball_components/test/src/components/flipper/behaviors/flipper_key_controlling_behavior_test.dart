// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';

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
    final flameTester = FlameTester(Forge2DGame.new);

    group(
      'onKeyEvent',
      () {
        late Flipper rightFlipper;
        late Flipper leftFlipper;

        setUp(() {
          rightFlipper = Flipper.test(side: BoardSide.right);
          leftFlipper = Flipper.test(side: BoardSide.left);
        });

        group('on right Flipper', () {
          flameTester.test(
            'moves upwards when right arrow is pressed',
            (game) async {
              await game.ensureAdd(rightFlipper);
              final behavior = FlipperKeyControllingBehavior();
              await rightFlipper.ensureAdd(behavior);

              final event = _MockRawKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowRight,
              );

              behavior.onKeyEvent(event, {});

              expect(rightFlipper.body.linearVelocity.y, isNegative);
              expect(rightFlipper.body.linearVelocity.x, isZero);
            },
          );

          flameTester.test(
            'moves downwards when right arrow is released',
            (game) async {
              await game.ensureAdd(rightFlipper);
              final behavior = FlipperKeyControllingBehavior();
              await rightFlipper.ensureAdd(behavior);

              final event = _MockRawKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowRight,
              );

              behavior.onKeyEvent(event, {});

              expect(rightFlipper.body.linearVelocity.y, isPositive);
              expect(rightFlipper.body.linearVelocity.x, isZero);
            },
          );

          flameTester.test(
            'moves upwards when D is pressed',
            (game) async {
              await game.ensureAdd(rightFlipper);
              final behavior = FlipperKeyControllingBehavior();
              await rightFlipper.ensureAdd(behavior);

              final event = _MockRawKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyD,
              );

              behavior.onKeyEvent(event, {});

              expect(rightFlipper.body.linearVelocity.y, isNegative);
              expect(rightFlipper.body.linearVelocity.x, isZero);
            },
          );

          flameTester.test(
            'moves downwards when D is released',
            (game) async {
              await game.ensureAdd(rightFlipper);
              final behavior = FlipperKeyControllingBehavior();
              await rightFlipper.ensureAdd(behavior);

              final event = _MockRawKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyD,
              );

              behavior.onKeyEvent(event, {});

              expect(rightFlipper.body.linearVelocity.y, isPositive);
              expect(rightFlipper.body.linearVelocity.x, isZero);
            },
          );

          group("doesn't move when", () {
            flameTester.test(
              'left arrow is pressed',
              (game) async {
                await game.ensureAdd(rightFlipper);
                final behavior = FlipperKeyControllingBehavior();
                await rightFlipper.ensureAdd(behavior);

                final event = _MockRawKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowLeft,
                );

                behavior.onKeyEvent(event, {});

                expect(rightFlipper.body.linearVelocity.y, isZero);
                expect(rightFlipper.body.linearVelocity.x, isZero);
              },
            );

            flameTester.test(
              'left arrow is released',
              (game) async {
                await game.ensureAdd(rightFlipper);
                final behavior = FlipperKeyControllingBehavior();
                await rightFlipper.ensureAdd(behavior);

                final event = _MockRawKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowLeft,
                );

                behavior.onKeyEvent(event, {});

                expect(rightFlipper.body.linearVelocity.y, isZero);
                expect(rightFlipper.body.linearVelocity.x, isZero);
              },
            );

            flameTester.test(
              'A is pressed',
              (game) async {
                await game.ensureAdd(rightFlipper);
                final behavior = FlipperKeyControllingBehavior();
                await rightFlipper.ensureAdd(behavior);

                final event = _MockRawKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyA,
                );

                behavior.onKeyEvent(event, {});

                expect(rightFlipper.body.linearVelocity.y, isZero);
                expect(rightFlipper.body.linearVelocity.x, isZero);
              },
            );

            flameTester.test(
              'A is released',
              (game) async {
                await game.ensureAdd(rightFlipper);
                final behavior = FlipperKeyControllingBehavior();
                await rightFlipper.ensureAdd(behavior);

                final event = _MockRawKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyA,
                );

                behavior.onKeyEvent(event, {});

                expect(rightFlipper.body.linearVelocity.y, isZero);
                expect(rightFlipper.body.linearVelocity.x, isZero);
              },
            );
          });
        });

        group('on left Flipper', () {
          flameTester.test(
            'moves upwards when left arrow is pressed',
            (game) async {
              await game.ensureAdd(leftFlipper);
              final behavior = FlipperKeyControllingBehavior();
              await leftFlipper.ensureAdd(behavior);

              final event = _MockRawKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowLeft,
              );

              behavior.onKeyEvent(event, {});

              expect(leftFlipper.body.linearVelocity.y, isNegative);
              expect(leftFlipper.body.linearVelocity.x, isZero);
            },
          );

          flameTester.test(
            'moves downwards when left arrow is released',
            (game) async {
              await game.ensureAdd(leftFlipper);
              final behavior = FlipperKeyControllingBehavior();
              await leftFlipper.ensureAdd(behavior);

              final event = _MockRawKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.arrowLeft,
              );

              behavior.onKeyEvent(event, {});

              expect(leftFlipper.body.linearVelocity.y, isPositive);
              expect(leftFlipper.body.linearVelocity.x, isZero);
            },
          );

          flameTester.test(
            'moves upwards when A is pressed',
            (game) async {
              await game.ensureAdd(leftFlipper);
              final behavior = FlipperKeyControllingBehavior();
              await leftFlipper.ensureAdd(behavior);

              final event = _MockRawKeyDownEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyA,
              );

              behavior.onKeyEvent(event, {});

              expect(leftFlipper.body.linearVelocity.y, isNegative);
              expect(leftFlipper.body.linearVelocity.x, isZero);
            },
          );

          flameTester.test(
            'moves downwards when A is released',
            (game) async {
              await game.ensureAdd(leftFlipper);
              final behavior = FlipperKeyControllingBehavior();
              await leftFlipper.ensureAdd(behavior);

              final event = _MockRawKeyUpEvent();
              when(() => event.logicalKey).thenReturn(
                LogicalKeyboardKey.keyA,
              );

              behavior.onKeyEvent(event, {});

              expect(leftFlipper.body.linearVelocity.y, isPositive);
              expect(leftFlipper.body.linearVelocity.x, isZero);
            },
          );

          group("doesn't move when", () {
            flameTester.test(
              'right arrow is pressed',
              (game) async {
                await game.ensureAdd(leftFlipper);
                final behavior = FlipperKeyControllingBehavior();
                await leftFlipper.ensureAdd(behavior);

                final event = _MockRawKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowRight,
                );

                behavior.onKeyEvent(event, {});

                expect(leftFlipper.body.linearVelocity.y, isZero);
                expect(leftFlipper.body.linearVelocity.x, isZero);
              },
            );

            flameTester.test(
              'right arrow is released',
              (game) async {
                await game.ensureAdd(leftFlipper);
                final behavior = FlipperKeyControllingBehavior();
                await leftFlipper.ensureAdd(behavior);

                final event = _MockRawKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.arrowRight,
                );

                behavior.onKeyEvent(event, {});

                expect(leftFlipper.body.linearVelocity.y, isZero);
                expect(leftFlipper.body.linearVelocity.x, isZero);
              },
            );

            flameTester.test(
              'D is pressed',
              (game) async {
                await game.ensureAdd(leftFlipper);
                final behavior = FlipperKeyControllingBehavior();
                await leftFlipper.ensureAdd(behavior);

                final event = _MockRawKeyDownEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyD,
                );

                behavior.onKeyEvent(event, {});

                expect(leftFlipper.body.linearVelocity.y, isZero);
                expect(leftFlipper.body.linearVelocity.x, isZero);
              },
            );

            flameTester.test(
              'D is released',
              (game) async {
                await game.ensureAdd(leftFlipper);
                final behavior = FlipperKeyControllingBehavior();
                await leftFlipper.ensureAdd(behavior);

                final event = _MockRawKeyUpEvent();
                when(() => event.logicalKey).thenReturn(
                  LogicalKeyboardKey.keyD,
                );

                behavior.onKeyEvent(event, {});

                expect(leftFlipper.body.linearVelocity.y, isZero);
                expect(leftFlipper.body.linearVelocity.x, isZero);
              },
            );
          });
        });
      },
    );
  });
}
