// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.boardBackground.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('BoardBackgroundSpriteComponent', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.images.loadAll(assets);
        final boardBackground = BoardBackgroundSpriteComponent();
        await game.ensureAdd(boardBackground);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<BoardBackgroundSpriteComponent>(),
          isNotEmpty,
        );
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final boardBackground = BoardBackgroundSpriteComponent();
        await game.world.ensureAdd(boardBackground);
        await tester.pump();

        game.camera
          ..moveTo(Vector2.zero())
          ..viewfinder.zoom = 3.7;
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/board_background.png'),
        );
      },
    );
  });
}
