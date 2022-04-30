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
    flameTester.test(
      'loads correctly',
      (game) async {
        final boardBackground = BoardBackgroundSpriteComponent();
        await game.ensureAdd(boardBackground);

        expect(game.contains(boardBackground), isTrue);
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        final boardBackground = BoardBackgroundSpriteComponent();
        await game.ensureAdd(boardBackground);
        await tester.pump();

        game.camera
          ..followVector2(Vector2.zero())
          ..zoom = 3.7;
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/board-background.png'),
        );
      },
    );
  });
}
