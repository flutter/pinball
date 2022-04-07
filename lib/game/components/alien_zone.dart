// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template alien_zone}
/// Area positioned below [Spaceship] where the [Ball]
/// can bounce off [AlienBumper]s.
///
/// When a [Ball] hits [AlienBumper]s, they toggle between activated and
/// deactivated states.
/// {@endtemplate}
class AlienZone extends Component with HasGameRef<PinballGame> {
  /// {@macro alien_zone}
  AlienZone();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    gameRef.addContactCallback(_ControlledAlienBumperBallContactCallback());

    final lowerBumper = _ControlledAlienBumper.a()
      ..initialPosition = Vector2(-32.52, 9.34);
    final upperBumper = _ControlledAlienBumper.b()
      ..initialPosition = Vector2(-22.89, 17.43);

    await addAll([
      lowerBumper,
      upperBumper,
    ]);
  }
}

class _ControlledAlienBumper extends AlienBumper
    with Controls<AlienBumperController>, ScorePoints {
  _ControlledAlienBumper.a() : super.a() {
    controller = AlienBumperController(this);
  }

  _ControlledAlienBumper.b() : super.b() {
    controller = AlienBumperController(this);
  }

  @override
  // TODO(ruimiguel): change points when get final points map.
  int get points => 10;
}

/// {@template alien_bumper_controller}
/// Controls a [AlienBumper].
/// {@endtemplate}
class AlienBumperController extends ComponentController<AlienBumper>
    with HasGameRef<PinballGame> {
  /// {@macro alien_bumper_controller}
  AlienBumperController(AlienBumper alienBumper) : super(alienBumper);

  /// Flag for activated state of the [AlienBumper].
  ///
  /// Used to toggle [AlienBumper]s' state between activated and deactivated.
  bool isActivated = false;

  /// Registers when a [AlienBumper] is hit by a [Ball].
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
class _ControlledAlienBumperBallContactCallback
    extends ContactCallback<Controls<AlienBumperController>, Ball> {
  @override
  void begin(
    Controls<AlienBumperController> controlledAlienBumper,
    Ball _,
    Contact __,
  ) {
    controlledAlienBumper.controller.hit();
  }
}
