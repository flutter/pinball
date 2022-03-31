// ignore_for_file: cascade_invocations

import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);
  group('BigDashNestBumper', () {
    flameTester.test('loads correctly', (game) async {
      final bigNest = BigDashNestBumper();
      await game.ensureAdd(bigNest);
      expect(game.contains(bigNest), isTrue);
    });
  });

  group('SmallDashNestBumper', () {
    flameTester.test('"a" loads correctly', (game) async {
      final smallNest = SmallDashNestBumper.a();
      await game.ensureAdd(smallNest);

      expect(game.contains(smallNest), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final smallNest = SmallDashNestBumper.b();
      await game.ensureAdd(smallNest);
      expect(game.contains(smallNest), isTrue);
    });
  });
}
