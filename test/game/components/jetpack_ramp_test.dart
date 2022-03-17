// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';

import '../../helpers/helpers.dart';

class MockJetpackRampArea extends Mock implements JetpackRampOpening {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(PinballGameTest.create);

  group('JetpackRamp', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final ramp = JetpackRamp(
          position: Vector2.zero(),
        );
        await game.ready();
        await game.ensureAdd(ramp);

        expect(game.contains(ramp), isTrue);
      },
    );

    group('children', () {
      flameTester.test(
        'has only one Pathway.arc',
        (game) async {
          final ramp = JetpackRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(ramp);

          expect(
            () => ramp.children.singleWhere(
              (component) => component is Pathway,
            ),
            returnsNormally,
          );
        },
      );

      flameTester.test(
        'has a two sensors for the ramp',
        (game) async {
          final ramp = JetpackRamp(
            position: Vector2.zero(),
          );
          await game.ready();
          await game.ensureAdd(ramp);

          final rampAreas =
              ramp.children.whereType<JetpackRampOpening>().toList();
          expect(rampAreas.length, 2);
        },
      );
    });
  });

  group('JetpackRampOpening', () {
    flameTester.test(
      'orientation is down',
      (game) async {
        final position = Vector2.all(10);
        final ramp = JetpackRampOpening(
          orientation: RampOrientation.down,
        )..initialPosition = position;
        await game.ready();
        await game.ensureAdd(ramp);

        expect(ramp.orientation, RampOrientation.down);
      },
    );
  });
}
