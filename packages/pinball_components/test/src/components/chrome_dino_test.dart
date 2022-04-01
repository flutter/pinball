// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('ChromeDino', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);

        expect(game.contains(chromeDino), isTrue);
      },
    );

    flameTester.test(
      'swivels',
      (game) async {
        // TODO(alestiago): Write golden tests to check the
        // swivel animation.
        final chromeDino = ChromeDino();
        await game.ensureAdd(chromeDino);

        final previousPosition = chromeDino.body.position.clone();
        game.update(64);

        expect(chromeDino.body.position, isNot(equals(previousPosition)));
      },
    );
  });
}
