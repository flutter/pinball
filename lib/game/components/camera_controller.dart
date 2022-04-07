import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// A [Component] that controls its game camera focus
class CameraController extends Component with HasGameRef, KeyboardHandler {
  /// The camera position for the board
  @visibleForTesting
  static final gamePosition = Vector2(0, -7.8);

  /// The camera position for the pinball panel
  @visibleForTesting
  static final backboardPosition = Vector2(0, -100.8);

  /// The zoom value for the game mode
  @visibleForTesting
  late final double gameZoom;

  /// The zoom value for the panel mode
  @visibleForTesting
  late final double backboardZoom;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameZoom = gameRef.size.y / 16;
    backboardZoom = gameRef.size.y / 18;

    // Game starts with the camera focused on the panel
    gameRef.camera
      ..speed = 100
      ..followVector2(backboardPosition)
      ..zoom = backboardZoom;
  }

  /// Move the camera focus to the game board
  Future<void> focusOnGame() async {
    final zoom = CameraZoom(value: gameZoom);
    unawaited(gameRef.add(zoom));
    await zoom.completed;
    gameRef.camera.moveTo(gamePosition);
  }

  /// Move the camera focus to the backboard
  Future<void> focusOnBackboard() async {
    final zoom = CameraZoom(value: backboardZoom);
    unawaited(gameRef.add(zoom));
    await zoom.completed;
    gameRef.camera.moveTo(backboardPosition);
  }
}
