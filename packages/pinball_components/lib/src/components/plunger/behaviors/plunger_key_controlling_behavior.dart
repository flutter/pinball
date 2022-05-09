import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';

/// Allows controlling the [Plunger]'s movement with keyboard input.
class PlungerKeyControllingBehavior extends Component
    with KeyboardHandler, FlameBlocReader<PlungerCubit, PlungerState> {
  /// The [LogicalKeyboardKey]s that will control the [Plunger].
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
      bloc.pulled();
    } else if (event is RawKeyUpEvent) {
      bloc.released();
    }

    return false;
  }
}
