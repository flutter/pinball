import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template controlled_plunger}
/// A [Plunger] with a [PlungerController] attached.
/// {@endtemplate}
class ControlledPlunger extends Plunger with Controls<PlungerController> {
  /// {@macro controlled_plunger}
  ControlledPlunger({required double compressionDistance})
      : super(compressionDistance: compressionDistance) {
    controller = PlungerController(this);
  }
}

/// {@template plunger_controller}
/// A [ComponentController] that controls a [Plunger]s movement.
/// {@endtemplate}
class PlungerController extends ComponentController<Plunger>
    with KeyboardHandler {
  /// {@macro plunger_controller}
  PlungerController(Plunger plunger) : super(plunger);

  /// The [LogicalKeyboardKey]s that will control the [Flipper].
  ///
  /// [onKeyEvent] method listens to when one of these keys is pressed.
  static const List<LogicalKeyboardKey> _keys = [
    LogicalKeyboardKey.arrowDown,
    LogicalKeyboardKey.space,
    LogicalKeyboardKey.keyS,
  ];

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!_keys.contains(event.logicalKey)) return true;

    if (event is RawKeyDownEvent) {
      component.pull();
    } else if (event is RawKeyUpEvent) {
      component.release();
    }

    return false;
  }
}
