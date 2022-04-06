import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

/// {@template camera_zoom}
/// Applies zoom to the camera of the game where this is added to
/// {@endtemplate}
class CameraZoom extends Effect with HasGameRef {
  /// {@macro camera_zoom}
  CameraZoom({
    required this.value,
  }) : super(
          EffectController(
            duration: 0.4,
            curve: Curves.easeOut,
          ),
        );

  /// The total zoom value to be applied to the camera
  final double value;

  late final Tween<double> _tween;

  final Completer<void> _completer = Completer();

  @override
  Future<void> onLoad() async {
    _tween = Tween(
      begin: gameRef.camera.zoom,
      end: value,
    );
  }

  @override
  void apply(double progress) {
    gameRef.camera.zoom = _tween.transform(progress);
  }

  /// Returns a [Future] that completes once the zoom is finished
  Future<void> get completed {
    if (controller.completed) {
      return Future.value();
    }

    return _completer.future;
  }

  @override
  void onRemove() {
    _completer.complete();

    super.onRemove();
  }
}
