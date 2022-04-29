// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.plunger.rocket.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('RocketSpriteComponent', () {
    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.images.loadAll(assets);
        await game.ensureAdd(RocketSpriteComponent());

        game.camera
          ..followVector2(Vector2.zero())
          ..zoom = 8;

        await tester.pump();
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/rocket.png'),
        );
      },
    );
  });
}
