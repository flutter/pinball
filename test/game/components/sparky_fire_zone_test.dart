// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.sparky.bumper.a.active.keyName,
    Assets.images.sparky.bumper.a.inactive.keyName,
    Assets.images.sparky.bumper.b.active.keyName,
    Assets.images.sparky.bumper.b.inactive.keyName,
    Assets.images.sparky.bumper.c.active.keyName,
    Assets.images.sparky.bumper.c.inactive.keyName,
    Assets.images.sparky.animatronic.keyName,
  ];

  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('SparkyFireZone', () {
    flameTester.test('loads correctly', (game) async {
      await game.addFromBlueprint(SparkyFireZone());
      await game.ready();
    });

    group('loads', () {
      flameTester.test(
        'a SparkyComputer',
        (game) async {
          expect(
            SparkyFireZone().blueprints.whereType<SparkyComputer>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'a SparkyAnimatronic',
        (game) async {
          final sparkyFireZone = SparkyFireZone();
          await game.addFromBlueprint(sparkyFireZone);
          await game.ready();

          expect(
            game.descendants().whereType<SparkyAnimatronic>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'three SparkyBumper',
        (game) async {
          final sparkyFireZone = SparkyFireZone();
          await game.addFromBlueprint(sparkyFireZone);
          await game.ready();

          expect(
            game.descendants().whereType<SparkyBumper>().length,
            equals(3),
          );
        },
      );
    });
  });

  group('SparkyComputerSensor', () {
    flameTester.test('calls turboCharge', (game) async {
      final sensor = SparkyComputerSensor();
      final ball = MockControlledBall();
      final controller = MockBallController();
      when(() => ball.controller).thenReturn(controller);
      when(controller.turboCharge).thenAnswer((_) async {});

      await game.ensureAddAll([
        sensor,
        SparkyAnimatronic(),
      ]);

      sensor.beginContact(ball, MockContact());

      verify(() => ball.controller.turboCharge()).called(1);
    });

    flameTester.test('plays SparkyAnimatronic', (game) async {
      final sensor = SparkyComputerSensor();
      final sparkyAnimatronic = SparkyAnimatronic();
      final ball = MockControlledBall();
      final controller = MockBallController();
      when(() => ball.controller).thenReturn(controller);
      when(controller.turboCharge).thenAnswer((_) async {});
      await game.ensureAddAll([
        sensor,
        sparkyAnimatronic,
      ]);

      expect(sparkyAnimatronic.playing, isFalse);
      sensor.beginContact(ball, MockContact());
      expect(sparkyAnimatronic.playing, isTrue);
    });
  });
}
