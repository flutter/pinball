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
        game.camera.zoom = 1;
        await game.ensureAdd(Panel(position: Vector2(0, 10)));
        await game.ensureAdd(CameraZoom(value: 8));
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
  });
}
