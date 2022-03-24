// ignore_for_file: cascade_invocations

import 'dart:collection';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group(
    'Flipper',
    () {
      // TODO(alestiago): Add golden tests.
      flameTester.test(
        'loads correctly',
        (game) async {
          final leftFlipper = Flipper(
            side: BoardSide.left,
          );
          final rightFlipper = Flipper(
            side: BoardSide.right,
          );
          await game.ready();
          await game.ensureAddAll([leftFlipper, rightFlipper]);

          expect(game.contains(leftFlipper), isTrue);
          expect(game.contains(rightFlipper), isTrue);
        },
      );

      group('constructor', () {
        test('sets BoardSide', () {
          final leftFlipper = Flipper(
            side: BoardSide.left,
          );

          expect(leftFlipper.side, equals(leftFlipper.side));

          final rightFlipper = Flipper(
            side: BoardSide.right,
          );
          expect(rightFlipper.side, equals(rightFlipper.side));
        });
      });

      group('body', () {
        flameTester.test(
          'is dynamic',
          (game) async {
            final flipper = Flipper(
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            expect(flipper.body.bodyType, equals(BodyType.dynamic));
          },
        );

        flameTester.test(
          'ignores gravity',
          (game) async {
            final flipper = Flipper(
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            expect(flipper.body.gravityScale, isZero);
          },
        );

        flameTester.test(
          'has greater mass than Ball',
          (game) async {
            final flipper = Flipper(
              side: BoardSide.left,
            );
            final ball = Ball(baseColor: Colors.white);

            await game.ready();
            await game.ensureAddAll([flipper, ball]);

            expect(
              flipper.body.getMassData().mass,
              greaterThan(ball.body.getMassData().mass),
            );
          },
        );
      });

      group('fixtures', () {
        flameTester.test(
          'has three',
          (game) async {
            final flipper = Flipper(
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            expect(flipper.body.fixtures.length, equals(3));
          },
        );

        flameTester.test(
          'has density',
          (game) async {
            final flipper = Flipper(
              side: BoardSide.left,
            );
            await game.ensureAdd(flipper);

            final fixtures = flipper.body.fixtures;
            final density = fixtures.fold<double>(
              0,
              (sum, fixture) => sum + fixture.density,
            );

            expect(density, greaterThan(0));
          },
        );
      });

      group('onKeyEvent', () {
        final leftKeys = UnmodifiableListView([
          LogicalKeyboardKey.arrowLeft,
          LogicalKeyboardKey.keyA,
        ]);
        final rightKeys = UnmodifiableListView([
          LogicalKeyboardKey.arrowRight,
          LogicalKeyboardKey.keyD,
        ]);

        group('and Flipper is left', () {
          late Flipper flipper;

          setUp(() {
            flipper = Flipper(
              side: BoardSide.left,
            );
          });

          testRawKeyDownEvents(leftKeys, (event) {
            flameTester.test(
              'moves upwards '
              'when ${event.logicalKey.keyLabel} is pressed',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isPositive);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyUpEvents(leftKeys, (event) {
            flameTester.test(
              'moves downwards '
              'when ${event.logicalKey.keyLabel} is released',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isNegative);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyUpEvents(rightKeys, (event) {
            flameTester.test(
              'does nothing '
              'when ${event.logicalKey.keyLabel} is released',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isZero);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyDownEvents(rightKeys, (event) {
            flameTester.test(
              'does nothing '
              'when ${event.logicalKey.keyLabel} is pressed',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isZero);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });
        });

        group('and Flipper is right', () {
          late Flipper flipper;

          setUp(() {
            flipper = Flipper(
              side: BoardSide.right,
            );
          });

          testRawKeyDownEvents(rightKeys, (event) {
            flameTester.test(
              'moves upwards '
              'when ${event.logicalKey.keyLabel} is pressed',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isPositive);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyUpEvents(rightKeys, (event) {
            flameTester.test(
              'moves downwards '
              'when ${event.logicalKey.keyLabel} is released',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isNegative);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyUpEvents(leftKeys, (event) {
            flameTester.test(
              'does nothing '
              'when ${event.logicalKey.keyLabel} is released',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isZero);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });

          testRawKeyDownEvents(leftKeys, (event) {
            flameTester.test(
              'does nothing '
              'when ${event.logicalKey.keyLabel} is pressed',
              (game) async {
                await game.ensureAdd(flipper);
                flipper.onKeyEvent(event, {});

                expect(flipper.body.linearVelocity.y, isZero);
                expect(flipper.body.linearVelocity.x, isZero);
              },
            );
          });
        });
      });
    },
  );
}
