// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(TestGame.new);

  flameTester.test(
    'loads correctly',
    (game) async {
      final fireEffect = FireEffect(
        burstPower: 1,
        direction: Vector2.zero(),
      );
      await game.ensureAdd(fireEffect);

      expect(game.contains(fireEffect), isTrue);
    },
  );
}
