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
    Assets.images.sparky.computer.top.keyName,
    Assets.images.sparky.computer.base.keyName,
    Assets.images.sparky.computer.glow.keyName,
    Assets.images.sparky.animatronic.keyName,
    Assets.images.sparky.bumper.a.lit.keyName,
    Assets.images.sparky.bumper.a.dimmed.keyName,
    Assets.images.sparky.bumper.b.lit.keyName,
    Assets.images.sparky.bumper.b.dimmed.keyName,
    Assets.images.sparky.bumper.c.lit.keyName,
    Assets.images.sparky.bumper.c.dimmed.keyName,
  ];

  final flameTester = FlameTester(
    () => EmptyPinballTestGame(assets: assets),
  );

  group('SparkyScorch', () {
    flameTester.test('loads correctly', (game) async {
      await game.addFromBlueprint(SparkyScorch());
      await game.ready();
    });

    group('loads', () {
      flameTester.test(
        'a SparkyComputer',
        (game) async {
          expect(
            SparkyScorch().blueprints.whereType<SparkyComputer>().single,
            isNotNull,
          );
        },
      );

      flameTester.test(
        'a SparkyAnimatronic',
        (game) async {
          final sparkysScorch = SparkyScorch();
          await game.addFromBlueprint(sparkysScorch);
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
          final sparkysScorch = SparkyScorch();
          await game.addFromBlueprint(sparkysScorch);
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
