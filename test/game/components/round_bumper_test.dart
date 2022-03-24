// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RoundBumper', () {
    final flameTester = FlameTester(Forge2DGame.new);
    const radius = 1.0;
    const points = 1;

    flameTester.test(
      'loads correctly',
      (game) async {
        await game.ready();
        final roundBumper = DashNestBumper(
          radius: radius,
          points: points,
        );
        await game.ensureAdd(roundBumper);

        expect(game.contains(roundBumper), isTrue);
      },
    );

    flameTester.test(
      'has points',
      (game) async {
        final roundBumper = DashNestBumper(
          radius: radius,
          points: points,
        );
        await game.ensureAdd(roundBumper);

        expect(roundBumper.points, equals(points));
      },
    );

    group('body', () {
      flameTester.test(
        'is static',
        (game) async {
          final roundBumper = DashNestBumper(
            radius: radius,
            points: points,
          );
          await game.ensureAdd(roundBumper);

          expect(roundBumper.body.bodyType, equals(BodyType.static));
        },
      );
    });

    group('fixture', () {
      flameTester.test(
        'exists',
        (game) async {
          final roundBumper = DashNestBumper(
            radius: radius,
            points: points,
          );
          await game.ensureAdd(roundBumper);

          expect(roundBumper.body.fixtures[0], isA<Fixture>());
        },
      );

      flameTester.test(
        'has restitution',
        (game) async {
          final roundBumper = DashNestBumper(
            radius: radius,
            points: points,
          );
          await game.ensureAdd(roundBumper);

          final fixture = roundBumper.body.fixtures[0];
          expect(fixture.restitution, greaterThan(0));
        },
      );

      flameTester.test(
        'shape is circular',
        (game) async {
          final roundBumper = DashNestBumper(
            radius: radius,
            points: points,
          );
          await game.ensureAdd(roundBumper);

          final fixture = roundBumper.body.fixtures[0];
          expect(fixture.shape.shapeType, equals(ShapeType.circle));
          expect(fixture.shape.radius, equals(1));
        },
      );
    });
  });
}
