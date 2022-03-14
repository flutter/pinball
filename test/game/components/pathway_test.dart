// ignore_for_file: cascade_invocations, prefer_const_constructors
import 'dart:math' as math;
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('Pathway', () {
    const width = 50.0;

    group('straight', () {
      group('color', () {
        flameTester.test(
          'has transparent color by default when no color is specified',
          (game) async {
            await game.ready();
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              width: width,
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
          'has a color when is specified',
          (game) async {
            await game.ready();
            const defaultColor = Colors.blue;

            final pathway = Pathway.straight(
              color: defaultColor,
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              width: width,
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
          await game.ready();
          final pathway = Pathway.straight(
            position: Vector2.zero(),
            start: Vector2(10, 10),
            end: Vector2(20, 20),
            width: width,
          );
          await game.ensureAdd(pathway);

          expect(game.contains(pathway), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            await game.ready();
            final position = Vector2.all(10);
            final pathway = Pathway.straight(
              position: position,
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              width: width,
            );
            await game.ensureAdd(pathway);

            game.contains(pathway);
            expect(pathway.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            await game.ready();
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              width: width,
            );
            await game.ensureAdd(pathway);

            expect(pathway.body.bodyType, equals(BodyType.static));
          },
        );
      });

      group('fixtures', () {
        flameTester.test(
          'has only one ChainShape when singleWall is true',
          (game) async {
            await game.ready();
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              width: width,
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
          'has two ChainShape when singleWall is false (default)',
          (game) async {
            await game.ready();
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              width: width,
            );
            await game.ensureAdd(pathway);

            expect(pathway.body.fixtures.length, 2);
            for (final fixture in pathway.body.fixtures) {
              expect(fixture, isA<Fixture>());
              expect(fixture.shape.shapeType, equals(ShapeType.chain));
            }
          },
        );

        flameTester.test(
          'has default filter categoryBits when not modified',
          (game) async {
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              width: width,
            );
            await game.ready();
            await game.ensureAdd(pathway);

            for (final fixture in pathway.body.fixtures) {
              expect(fixture, isA<Fixture>());
              expect(
                fixture.filterData.categoryBits,
                equals(Filter().categoryBits),
              );
            }
          },
        );

        flameTester.test(
          'sets correctly filter categoryBits ',
          (game) async {
            const maskBits = 1234;
            final pathway = Pathway.straight(
              position: Vector2.zero(),
              start: Vector2(10, 10),
              end: Vector2(20, 20),
              width: width,
              categoryBits: maskBits,
            );
            await game.ready();
            await game.ensureAdd(pathway);

            for (final fixture in pathway.body.fixtures) {
              expect(fixture, isA<Fixture>());
              expect(
                fixture.filterData.categoryBits,
                equals(maskBits),
              );
            }
          },
        );
      });
    });

    group('arc', () {
      flameTester.test(
        'loads correctly',
        (game) async {
          await game.ready();
          final pathway = Pathway.arc(
            position: Vector2.zero(),
            width: width,
            radius: 100,
            angle: math.pi / 2,
          );
          await game.ensureAdd(pathway);

          expect(game.contains(pathway), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            await game.ready();
            final position = Vector2.all(10);
            final pathway = Pathway.arc(
              position: position,
              width: width,
              radius: 100,
              angle: math.pi / 2,
            );
            await game.ensureAdd(pathway);

            game.contains(pathway);
            expect(pathway.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            await game.ready();
            final pathway = Pathway.arc(
              position: Vector2.zero(),
              width: width,
              radius: 100,
              angle: math.pi / 2,
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
          await game.ready();
          final pathway = Pathway.bezierCurve(
            position: Vector2.zero(),
            controlPoints: controlPoints,
            width: width,
          );
          await game.ensureAdd(pathway);

          expect(game.contains(pathway), isTrue);
        },
      );

      group('body', () {
        flameTester.test(
          'positions correctly',
          (game) async {
            await game.ready();
            final position = Vector2.all(10);
            final pathway = Pathway.bezierCurve(
              position: position,
              controlPoints: controlPoints,
              width: width,
            );
            await game.ensureAdd(pathway);

            game.contains(pathway);
            expect(pathway.body.position, position);
          },
        );

        flameTester.test(
          'is static',
          (game) async {
            await game.ready();
            final pathway = Pathway.bezierCurve(
              position: Vector2.zero(),
              controlPoints: controlPoints,
              width: width,
            );
            await game.ensureAdd(pathway);

            expect(pathway.body.bodyType, equals(BodyType.static));
          },
        );
      });
    });
  });
}
