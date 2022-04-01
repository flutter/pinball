import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template camera_zoom}
/// Applies zoom to the camera of the game where this is added to
/// {@endtemplate}
class CameraZoom extends CurveComponent with HasGameRef {
  /// {@macro camera_zoom}
  CameraZoom({
    required this.value,
  }) : super(
          curve: Curves.easeOut,
          duration: 0.4,
        );

  /// The total zoom value to be applied to the camera
  final double value;

  late Tween<double> _tween;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _tween = Tween(
      begin: gameRef.camera.zoom,
      end: value,
    );
  }

  @override
  void apply(double progress) {
    gameRef.camera.zoom = _tween.transform(progress);
  }
}
