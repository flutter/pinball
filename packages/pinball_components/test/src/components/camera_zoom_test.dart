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
        game.camera.followVector2(Vector2.zero());
        game.camera.zoom = 10;
        final sprite = await game.loadSprite(
          Assets.images.signpost.inactive.keyName,
        );

        await game.add(
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

    tester.test(
      'completes when checked after it is finished',
      (game) async {
        await game.add(CameraZoom(value: 40));
        game.update(10);
        final cameraZoom = game.firstChild<CameraZoom>();
        final future = cameraZoom!.completed;

        expect(future, completes);
      },
    );

    tester.test(
      'completes when checked before it is finished',
      (game) async {
        final zoom = CameraZoom(value: 40);
        final future = zoom.completed;

        await game.add(zoom);
        game.update(10);
        game.update(0);

        expect(future, completes);
      },
    );
  });
}
