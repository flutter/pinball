// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

// TODO(ruimiguel): create and add SparkyFireZone component here in other PR.

class ControlledSparkyBumper extends SparkyBumper
    with Controls<_SparkyBumperController> {
  ControlledSparkyBumper() : super.a() {
    controller = _SparkyBumperController(this);
  }
}

/// {@template sparky_bumper_controller}
/// Controls a [SparkyBumper].
/// {@endtemplate}
class _SparkyBumperController extends ComponentController<SparkyBumper>
    with HasGameRef<PinballGame> {
  /// {@macro sparky_bumper_controller}
  _SparkyBumperController(SparkyBumper sparkyBumper) : super(sparkyBumper);

  /// Flag for activated state of the [SparkyBumper].
  ///
  /// Used to toggle [SparkyBumper]s' state between activated and deactivated.
  bool isActivated = false;

  /// Registers when a [SparkyBumper] is hit by a [Ball].
  ///
  /// Triggered by [ControlledSparkyBumperBallContactCallback].
  void hit() {
    if (isActivated) {
      component.deactivate();
    } else {
      component.activate();
    }
    isActivated = !isActivated;
  }
}
