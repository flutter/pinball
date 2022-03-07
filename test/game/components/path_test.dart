// ignore_for_file: cascade_invocations, prefer_const_constructors
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGame.new);

  group('Pathway', () {
    const pathwayWidth = 50.0;

    group('straight', () {
      group('color', () {
        flameTester.test(
          'has transparent color by default if not specified',
          (game) async {
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathwayWidth: pathwayWidth,
            );
            await game.ensureAdd(pathway);
            expect(game.contains(pathway), isTrue);
            expect(pathway.paint, isNotNull);
            expect(
              pathway.paint.color,
              equals(Color.fromARGB(0, 0, 0, 0)),
            );
          },
        );
        flameTester.test(
          'has a color if set',
          (game) async {
            const defaultColor = Colors.blue;

            final pathway = Pathway.straight(
              color: defaultColor,
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathwayWidth: pathwayWidth,
            );
            await game.ensureAdd(pathway);
            expect(game.contains(pathway), isTrue);
            expect(pathway.paint, isNotNull);
            expect(pathway.paint.color.value, equals(defaultColor.value));
          },
        );
      });

      flameTester.test(
        'loads correctly',
        (game) async {
          final pathway = Pathway.straight(
            position: Vector2.zero(),
            start: Vector2(10, 10),
            end: Vector2(20, 20),
            pathwayWidth: pathwayWidth,
          );
          await game.ensureAdd(pathway);
          expect(game.contains(pathway), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            final position = Vector2.all(10);
            final pathway = Pathway.straight(
              position: position,
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathwayWidth: pathwayWidth,
            );
            await game.ensureAdd(pathway);
            game.contains(pathway);

            expect(pathway.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathwayWidth: pathwayWidth,
            );
            await game.ensureAdd(pathway);

            expect(pathway.body.bodyType, equals(BodyType.static));
          },
        );
      });

      group('fixtures', () {
        flameTester.test(
          'exists only one ChainShape if just one wall',
          (game) async {
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathwayWidth: pathwayWidth,
              singleWall: true,
            );
            await game.ensureAdd(pathway);

            expect(pathway.body.fixtures.length, 1);
            final fixture = pathway.body.fixtures[0];
            expect(fixture, isA<Fixture>());
            expect(fixture.shape.shapeType, equals(ShapeType.chain));
          },
        );

        flameTester.test(
          'exists two ChainShape if there is by default two walls',
          (game) async {
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              pathwayWidth: pathwayWidth,
            );
            await game.ensureAdd(pathway);

            expect(pathway.body.fixtures.length, 2);
            for (final fixture in pathway.body.fixtures) {
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
          final pathway = Pathway.arc(
            position: Vector2.zero(),
            pathwayWidth: pathwayWidth,
            radius: 100,
            angle: 90,
          );
          await game.ensureAdd(pathway);
          expect(game.contains(pathway), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            final position = Vector2.all(10);
            final pathway = Pathway.arc(
              position: position,
              pathwayWidth: pathwayWidth,
              radius: 100,
              angle: 90,
            );
            await game.ensureAdd(pathway);
            game.contains(pathway);

            expect(pathway.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            final pathway = Pathway.arc(
              position: Vector2.zero(),
              pathwayWidth: pathwayWidth,
              radius: 100,
              angle: 90,
            );
            await game.ensureAdd(pathway);

            expect(pathway.body.bodyType, equals(BodyType.static));
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
          final pathway = Pathway.bezierCurve(
            position: Vector2.zero(),
            controlPoints: controlPoints,
            pathwayWidth: pathwayWidth,
          );
          await game.ensureAdd(pathway);
          expect(game.contains(pathway), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            final position = Vector2.all(10);
            final pathway = Pathway.bezierCurve(
              position: position,
              controlPoints: controlPoints,
              pathwayWidth: pathwayWidth,
            );
            await game.ensureAdd(pathway);
            game.contains(pathway);

            expect(pathway.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            final pathway = Pathway.bezierCurve(
              position: Vector2.zero(),
              controlPoints: controlPoints,
              pathwayWidth: pathwayWidth,
            );
            await game.ensureAdd(pathway);

            expect(pathway.body.bodyType, equals(BodyType.static));
          },
        );
      });
    });
  });
}
