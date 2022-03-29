import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/game.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final flameTester = FlameTester(Forge2DGame.new);

  group('ChromeDino', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final chromeDino = ChromeDino();

        await game.ready();
        await game.ensureAdd(chromeDino);

        expect(game.contains(chromeDino), isTrue);
      },
    );
  });
}
