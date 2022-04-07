// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

// TODO(ruimiguel): create and add SparkyFireZone component here in other PR.

/// {@template sparky_bumper_controller}
/// Controls a [SparkyBumper].
/// {@endtemplate}
@visibleForTesting
class SparkyBumperController extends ComponentController<SparkyBumper>
    with HasGameRef<PinballGame> {
  /// {@macro sparky_bumper_controller}
  SparkyBumperController(SparkyBumper sparkyBumper) : super(sparkyBumper);

  /// Flag for activated state of the [SparkyBumper].
  ///
  /// Used to toggle [SparkyBumper]s' state between activated and deactivated.
  bool _isActivated = false;

  /// Registers when a [SparkyBumper] is hit by a [Ball].
  void hit() {
    if (_isActivated) {
      component.deactivate();
    } else {
      component.activate();
    }
    _isActivated = !_isActivated;
  }
}
