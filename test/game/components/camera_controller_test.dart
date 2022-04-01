import 'dart:async';

import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinball/game/components/camera_controller.dart';
import 'package:pinball_components/pinball_components.dart';

import '../../helpers/helpers.dart';

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
      expect(controller.panelZoom.toInt(), equals(16));
    });

    test('correctly sets the initial zoom and position', () async {
      expect(game.camera.zoom, equals(controller.panelZoom));
      expect(game.camera.follow, equals(CameraController.panelPosition));
    });

    group('focusOnBoard', () {
      test('changes the zoom', () async {
        unawaited(controller.focusOnBoard());

        await game.ready();
        final zoom = game.firstChild<CameraZoom>();
        expect(zoom, isNotNull);
        expect(zoom?.value, equals(controller.gameZoom));
      });

      test('moves the camera after the zoom is completed', () async {
        final future = controller.focusOnBoard();
        await game.ready();

        game.update(10);

        await future;

        expect(game.camera.position, Vector2(-3, -106.8));
      });

      test('moves the camera when enter is pressed', () async {
        testRawKeyUpEvents([LogicalKeyboardKey.enter], (key) async {
          controller.onKeyEvent(key, {});
          await game.ready();

          game.update(10);

          expect(game.camera.position, Vector2(-3, -106.8));
        });
      });

      test('does nothing when another key is pressed', () async {
        testRawKeyUpEvents([LogicalKeyboardKey.keyA], (key) async {
          final originalPosition = game.camera.position;
          controller.onKeyEvent(key, {});
          await game.ready();

          game.update(10);

          expect(game.camera.position, originalPosition);
        });
      });
    });
  });
}
