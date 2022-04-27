// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/dash_nest_bumper/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashNestBumper', () {
    final assets = [
      Assets.images.dash.bumper.main.active.keyName,
      Assets.images.dash.bumper.main.inactive.keyName,
      Assets.images.dash.bumper.a.active.keyName,
      Assets.images.dash.bumper.a.inactive.keyName,
      Assets.images.dash.bumper.b.active.keyName,
      Assets.images.dash.bumper.b.inactive.keyName,
    ];
    final flameTester = FlameTester(() => TestGame(assets));

    flameTester.test('"main" loads correctly', (game) async {
      final bumper = DashNestBumper.main();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"a" loads correctly', (game) async {
      final bumper = DashNestBumper.a();
      await game.ensureAdd(bumper);

      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final bumper = DashNestBumper.b();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    group('adds', () {
      flameTester.test('adds new children', (game) async {
        final component = Component();
        final dashNestBumper = DashNestBumper.a(
          children: [component],
        );
        await game.ensureAdd(dashNestBumper);
        expect(dashNestBumper.children, contains(component));
      });

      flameTester.test('an DashNestBumperBallContactBehavior', (game) async {
        final dashNestBumper = DashNestBumper.a();
        await game.ensureAdd(dashNestBumper);
        expect(
          dashNestBumper.children
              .whereType<DashNestBumperBallContactBehavior>()
              .single,
          isNotNull,
        );
      });
    });
  });
}
