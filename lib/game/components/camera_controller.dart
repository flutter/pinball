import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';

/// A [Component] that controls its game camera focus
class CameraController extends Component with HasGameRef, KeyboardHandler {
  /// The camera position for the board
  static final zeroPosition = Vector2(0, -7.8);

  /// The camera position for the pinball panel
  static final panelPosition = Vector2(0, -100.8);

  /// The zoom value for the game mode
  late final double gameZoom;

  /// The zoom value for the panel mode
  late final double panelZoom;
  bool _isFocusingOnBoard = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameZoom = gameRef.size.y / 16;
    panelZoom = gameRef.size.y / 12;

    // Game starts with the camera focused on the panel
    gameRef.camera
      ..speed = 200
      ..followVector2(panelPosition)
      ..zoom = panelZoom;
  }

  /// Move the camera focus to the game board
  Future<void> focusOnBoard() async {
    final zoom = CameraZoom(value: gameZoom);
    unawaited(gameRef.add(zoom));
    await zoom.completed;
    gameRef.camera.moveTo(zeroPosition);
  }

  // TODO(erickzanardo): Just for testing while
  // we don't get the panel designs, which will be
  // where this event will be generated from
  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!_isFocusingOnBoard) {
      if (event is RawKeyUpEvent &&
          event.logicalKey == LogicalKeyboardKey.enter) {
        _isFocusingOnBoard = true;
        focusOnBoard();
        return true;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
