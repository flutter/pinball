// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_fire_zone}
/// Area positioned at the top left of the [Board] where the [Ball]
/// can bounce off [SparkyBumper]s.
///
/// When a [Ball] hits [SparkyBumper]s, they toggle between activated and
/// deactivated states.
/// {@endtemplate}
class SparkyFireZone extends Component with HasGameRef<PinballGame> {
  /// {@macro sparky_fire_zone}
  SparkyFireZone();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameRef.addContactCallback(_ControlledSparkyBumperBallContactCallback());

    final lowerLeftBumper = ControlledSparkyBumper.a()
      ..initialPosition = Vector2(-23.15, -41.65);
    final upperLeftBumper = ControlledSparkyBumper.b()
      ..initialPosition = Vector2(-21.25, -58.15);
    final rightBumper = ControlledSparkyBumper.c()
      ..initialPosition = Vector2(-3.56, -53.051);

    await addAll([
      lowerLeftBumper,
      upperLeftBumper,
      rightBumper,
    ]);
  }
}

/// {@template controlled_sparky_bumper}
/// [SparkyBumper] with [_SparkyBumperController] attached.
/// {@endtemplate}
@visibleForTesting
class ControlledSparkyBumper extends SparkyBumper
    with Controls<_SparkyBumperController>, ScorePoints {
  ///{@macro controlled_sparky_bumper}
  ControlledSparkyBumper.a() : super.a() {
    controller = _SparkyBumperController(this);
  }

  ///{@macro controlled_sparky_bumper}
  ControlledSparkyBumper.b() : super.b() {
    controller = _SparkyBumperController(this);
  }

  ///{@macro controlled_sparky_bumper}
  ControlledSparkyBumper.c() : super.c() {
    controller = _SparkyBumperController(this);
  }

  @override
  int get points => 20;
}

/// {@template sparky_bumper_controller}
/// Controls a [SparkyBumper].
/// {@endtemplate}
class _SparkyBumperController extends ComponentController<SparkyBumper>
    with HasGameRef<PinballGame> {
  /// {@macro sparky_bumper_controller}
  _SparkyBumperController(ControlledSparkyBumper controlledSparkyBumper)
      : super(controlledSparkyBumper);

  /// Flag for activated state of the [SparkyBumper].
  ///
  /// Used to toggle [SparkyBumper]s' state between activated and deactivated.
  bool isActivated = false;

  /// Registers when a [SparkyBumper] is hit by a [Ball].
  void hit() {
    if (isActivated) {
      component.deactivate();
    } else {
      component.activate();
    }
    isActivated = !isActivated;
  }
}

/// Listens when a [Ball] bounces bounces against a [SparkyBumper].
class _ControlledSparkyBumperBallContactCallback
    extends ContactCallback<Controls<_SparkyBumperController>, Ball> {
  @override
  void begin(
    Controls<_SparkyBumperController> controlledSparkyBumper,
    Ball _,
    Contact __,
  ) {
    controlledSparkyBumper.controller.hit();
  }
}
