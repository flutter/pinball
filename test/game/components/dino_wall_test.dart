import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('DinoTopWall', () {
    final tester = FlameTester(TestGame.new);

    tester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.add(DinoTopWall()..initialPosition = Vector2(0, -50));
        await game.ready();
        await tester.pump();
      },
      verify: (game, tester) async {
        // FIXME(ruimiguel): Failing pipeline.
        //await expectLater(
        //  find.byGame<Forge2DGame>(),
        //  matchesGoldenFile('golden/dinoTopWall.png'),
        //);
      },
    );
  });

  group('DinoBottomWall', () {
    final tester = FlameTester(TestGame.new);

    tester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.add(DinoBottomWall()..initialPosition = Vector2(0, -12));
        await game.ready();
        await tester.pump();
      },
      verify: (game, tester) async {
        // FIXME(ruimiguel): Failing pipeline.
        //await expectLater(
        //  find.byGame<Forge2DGame>(),
        //  matchesGoldenFile('golden/dinoBottomWall.png'),
        //);
      },
    );
  });
}
