import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Allows controlling the [Plunger]'s movement with keyboard input.
class PlungerKeyControllingBehavior extends Component
    with KeyboardHandler, ParentIsA<Plunger> {
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
      parent.pull();
    } else if (event is RawKeyUpEvent) {
      parent.release();
    }

    return false;
  }
}
