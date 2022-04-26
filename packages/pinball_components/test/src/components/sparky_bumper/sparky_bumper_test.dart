// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.sparky.bumper.a.active.keyName,
    Assets.images.sparky.bumper.a.inactive.keyName,
    Assets.images.sparky.bumper.b.active.keyName,
    Assets.images.sparky.bumper.b.inactive.keyName,
    Assets.images.sparky.bumper.c.active.keyName,
    Assets.images.sparky.bumper.c.inactive.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('SparkyBumper', () {
    flameTester.test('"a" loads correctly', (game) async {
      final bumper = SparkyBumper.a();
      await game.ensureAdd(bumper);

      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final bumper = SparkyBumper.b();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });

    flameTester.test('"c" loads correctly', (game) async {
      final bumper = SparkyBumper.c();
      await game.ensureAdd(bumper);
      expect(game.contains(bumper), isTrue);
    });
  });
}
