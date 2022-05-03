// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

class _MockControlledBall extends Mock implements ControlledBall {}

class _MockBallController extends Mock implements BallController {}

class _MockContact extends Mock implements Contact {}

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
      final component = SparkyScorch();
      await game.ensureAdd(component);
      expect(game.contains(component), isTrue);
    });

    group('loads', () {
      flameTester.test(
        'a SparkyComputer',
        (game) async {
          await game.ensureAdd(SparkyScorch());
          expect(
            game.descendants().whereType<SparkyComputer>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'a SparkyAnimatronic',
        (game) async {
          await game.ensureAdd(SparkyScorch());
          expect(
            game.descendants().whereType<SparkyAnimatronic>().length,
            equals(1),
          );
        },
      );

      flameTester.test(
        'three SparkyBumper',
        (game) async {
          await game.ensureAdd(SparkyScorch());
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
      final ball = _MockControlledBall();
      final controller = _MockBallController();
      when(() => ball.controller).thenReturn(controller);
      when(controller.turboCharge).thenAnswer((_) async {});

      await game.ensureAddAll([
        sensor,
        SparkyAnimatronic(),
      ]);

      sensor.beginContact(ball, _MockContact());

      verify(() => ball.controller.turboCharge()).called(1);
    });

    flameTester.test('plays SparkyAnimatronic', (game) async {
      final sensor = SparkyComputerSensor();
      final sparkyAnimatronic = SparkyAnimatronic();
      final ball = _MockControlledBall();
      final controller = _MockBallController();
      when(() => ball.controller).thenReturn(controller);
      when(controller.turboCharge).thenAnswer((_) async {});
      await game.ensureAddAll([
        sensor,
        sparkyAnimatronic,
      ]);

      expect(sparkyAnimatronic.playing, isFalse);
      sensor.beginContact(ball, _MockContact());
      expect(sparkyAnimatronic.playing, isTrue);
    });
  });
}
