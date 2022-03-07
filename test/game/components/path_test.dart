// ignore_for_file: cascade_invocations

import 'dart:math';
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGame.new);

  group('Path', () {
    const pathWidth = 50.0;

    group('straight', () {
      group('color', () {
        flameTester.test(
          'has white color by default if not specified',
          (game) async {
            final path = Path.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathWidth: pathWidth,
            );
            await game.ensureAdd(path);
            expect(game.contains(path), isTrue);
            expect(path.paint, isNotNull);
            expect(path.paint.color, equals(Colors.white));
          },
        );
        flameTester.test(
          'has a color if set',
          (game) async {
            const defaultColor = Colors.blue;

            final path = Path.straight(
              color: defaultColor,
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathWidth: pathWidth,
            );
            await game.ensureAdd(path);
            expect(game.contains(path), isTrue);
            expect(path.paint, isNotNull);
            expect(path.paint.color.value, equals(defaultColor.value));
          },
        );
      });

      flameTester.test(
        'loads correctly',
        (game) async {
          final path = Path.straight(
            position: Vector2.zero(),
            start: Vector2(10, 10),
            end: Vector2(20, 20),
            pathWidth: pathWidth,
          );
          await game.ensureAdd(path);
          expect(game.contains(path), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            final position = Vector2.all(10);
            final path = Path.straight(
              position: position,
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathWidth: pathWidth,
            );
            await game.ensureAdd(path);
            game.contains(path);

            expect(path.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            final path = Path.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathWidth: pathWidth,
            );
            await game.ensureAdd(path);

            expect(path.body.bodyType, equals(BodyType.static));
          },
        );
      });

      group('fixtures', () {
        flameTester.test(
          'exists only one ChainShape if just one wall',
          (game) async {
            final path = Path.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathWidth: pathWidth,
              onlyOneWall: true,
            );
            await game.ensureAdd(path);

            expect(path.body.fixtures.length, 1);
            final fixture = path.body.fixtures[0];
            expect(fixture, isA<Fixture>());
            expect(fixture.shape.shapeType, equals(ShapeType.chain));
          },
        );

        flameTester.test(
          'exists two ChainShape if there is by default two walls',
          (game) async {
            final path = Path.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathWidth: pathWidth,
            );
            await game.ensureAdd(path);

            expect(path.body.fixtures.length, 2);
            for (var fixture in path.body.fixtures) {
              expect(fixture, isA<Fixture>());
              expect(fixture.shape.shapeType, equals(ShapeType.chain));
            }
          },
        );
      });
    });

    group('arc', () {
      flameTester.test(
        'loads correctly',
        (game) async {
          final path = Path.arc(
            position: Vector2.zero(),
            pathWidth: pathWidth,
            radius: 100,
            angle: 90,
          );
          await game.ensureAdd(path);
          expect(game.contains(path), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            final position = Vector2.all(10);
            final path = Path.arc(
              position: position,
              pathWidth: pathWidth,
              radius: 100,
              angle: 90,
            );
            await game.ensureAdd(path);
            game.contains(path);

            expect(path.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            final path = Path.arc(
              position: Vector2.zero(),
              pathWidth: pathWidth,
              radius: 100,
              angle: 90,
            );
            await game.ensureAdd(path);

            expect(path.body.bodyType, equals(BodyType.static));
          },
        );
      });
    });

    group('bezier curve', () {
      final controlPoints = [
        Vector2(0, 0),
        Vector2(50, 0),
        Vector2(0, 50),
        Vector2(50, 50),
      ];

      flameTester.test(
        'loads correctly',
        (game) async {
          final path = Path.bezierCurve(
            position: Vector2.zero(),
            controlPoints: controlPoints,
            pathWidth: pathWidth,
          );
          await game.ensureAdd(path);
          expect(game.contains(path), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            final position = Vector2.all(10);
            final path = Path.bezierCurve(
              position: position,
              controlPoints: controlPoints,
              pathWidth: pathWidth,
            );
            await game.ensureAdd(path);
            game.contains(path);

            expect(path.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            final path = Path.bezierCurve(
              position: Vector2.zero(),
              controlPoints: controlPoints,
              pathWidth: pathWidth,
            );
            await game.ensureAdd(path);

            expect(path.body.bodyType, equals(BodyType.static));
          },
        );
      });
    });
  });
}
