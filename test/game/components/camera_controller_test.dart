// ignore_for_file: cascade_invocations

import 'dart:async';

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

      controller = CameraController();
      await game.ensureAdd(controller);
    });

    test('loads correctly', () async {
      expect(game.firstChild<CameraController>(), isNotNull);
    });

    test('correctly calculates the zooms', () async {
      expect(controller.gameZoom.toInt(), equals(12));
      expect(controller.backboardZoom.toInt(), equals(11));
    });

    test('correctly sets the initial zoom and position', () async {
      expect(game.camera.zoom, equals(controller.backboardZoom));
      expect(game.camera.follow, equals(CameraController.backboardPosition));
    });

    group('focusOnBoard', () {
      test('changes the zoom', () async {
        unawaited(controller.focusOnGame());

        await game.ready();
        final zoom = game.firstChild<CameraZoom>();
        expect(zoom, isNotNull);
        expect(zoom?.value, equals(controller.gameZoom));
      });

      test('moves the camera after the zoom is completed', () async {
        final future = controller.focusOnGame();
        await game.ready();

        game.update(10);
        game.update(0); // Ensure that the component was removed

        await future;

        expect(game.camera.position, Vector2(-4, -108.8));
      });
    });

    group('focusOnBackboard', () {
      test('changes the zoom', () async {
        unawaited(controller.focusOnBackboard());

        await game.ready();
        final zoom = game.firstChild<CameraZoom>();
        expect(zoom, isNotNull);
        expect(zoom?.value, equals(controller.backboardZoom));
      });

      test('moves the camera after the zoom is completed', () async {
        final future = controller.focusOnBackboard();
        await game.ready();

        game.update(10);
        game.update(0); // Ensure that the component was removed

        await future;

        expect(game.camera.position, Vector2(-4.5, -109.8));
      });
    });
  });
}
