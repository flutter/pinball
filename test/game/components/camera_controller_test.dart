// ignore_for_file: cascade_invocations

import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/camera_controller.dart';
import 'package:pinball_components/pinball_components.dart';

void main() {
  group('CameraController', () {
    late FlameGame game;
    late CameraController controller;

    setUp(() async {
      game = FlameGame()..onGameResize(Vector2(100, 200));

      controller = CameraController(game);
      await game.ensureAdd(controller);
    });

    test('loads correctly', () async {
      expect(game.firstChild<CameraController>(), isNotNull);
    });

    test('correctly calculates the zooms', () async {
      expect(controller.gameFocus.zoom.toInt(), equals(12));
      expect(controller.backboardFocus.zoom.toInt(), equals(11));
    });

    test('correctly sets the initial zoom and position', () async {
      expect(game.camera.zoom, equals(controller.backboardFocus.zoom));
      expect(game.camera.follow, equals(controller.backboardFocus.position));
    });

    group('focusOnBoard', () {
      test('changes the zoom', () async {
        controller.focusOnGame();

        await game.ready();
        final zoom = game.firstChild<CameraZoom>();
        expect(zoom, isNotNull);
        expect(zoom?.value, equals(controller.gameFocus.zoom));
      });

      test('moves the camera after the zoom is completed', () async {
        controller.focusOnGame();
        await game.ready();
        final cameraZoom = game.firstChild<CameraZoom>()!;
        final future = cameraZoom.completed;

        game.update(10);
        game.update(0); // Ensure that the component was removed

        await future;

        expect(game.camera.position, Vector2(-4, -108.8));
      });
    });

    group('focusOnBackboard', () {
      test('changes the zoom', () async {
        controller.focusOnBackboard();

        await game.ready();
        final zoom = game.firstChild<CameraZoom>();
        expect(zoom, isNotNull);
        expect(zoom?.value, equals(controller.backboardFocus.zoom));
      });

      test('moves the camera after the zoom is completed', () async {
        controller.focusOnBackboard();
        await game.ready();
        final cameraZoom = game.firstChild<CameraZoom>()!;
        final future = cameraZoom.completed;

        game.update(10);
        game.update(0); // Ensure that the component was removed

        await future;

        expect(game.camera.position, Vector2(-4.5, -109.8));
      });
    });
  });
}
