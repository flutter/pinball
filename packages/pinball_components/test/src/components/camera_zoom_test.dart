// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

void main() {
  group('CameraZoom', () {
    final tester = FlameTester(TestGame.new);

    tester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        game.camera.moveTo(Vector2.zero());
        game.camera.viewfinder.zoom = 10;
        final sprite = await game.loadSprite(
          Assets.images.signpost.inactive.keyName,
        );

        await game.world.add(
          SpriteComponent(
            sprite: sprite,
            size: Vector2(4, 8),
            anchor: Anchor.center,
          ),
        );

        await game.add(CameraZoom(value: 40));
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/camera_zoom/no_zoom.png'),
        );

        game.update(0.2);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/camera_zoom/in_between.png'),
        );

        game.update(0.4);
        await tester.pump();
        await expectLater(
          find.byGame<TestGame>(),
          matchesGoldenFile('golden/camera_zoom/finished.png'),
        );
        game.update(0.1);
        await tester.pump();

        expect(game.firstChild<CameraZoom>(), isNull);
      },
    );

    tester.testGameWidget(
      'completes when checked after it is finished',
      setUp: (game, _) async {
        await game.add(CameraZoom(value: 40));
      },
      verify: (game, _) async {
        game.update(10);
        final cameraZoom = game.descendants().whereType<CameraZoom>().single;
        final future = cameraZoom.completed;

        expect(future, completes);
      },
    );

    tester.testGameWidget(
      'completes when checked before it is finished',
      setUp: (game, _) async {
        final zoom = CameraZoom(value: 40);
        await game.add(zoom);
      },
      verify: (game, _) async {
        final cameraZoom = game.descendants().whereType<CameraZoom>().single;
        final completed = cameraZoom.completed;
        game.update(10);
        game.update(0);

        expect(completed, completes);
      },
    );
  });
}
