import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Allows controlling the [Flipper]'s movement with keyboard input.
class FlipperKeyControllingBehavior extends Component
    with KeyboardHandler, ParentIsA<Flipper> {
  /// The [LogicalKeyboardKey]s that will control the [Flipper].
  ///
  /// [onKeyEvent] method listens to when one of these keys is pressed.
  late final List<LogicalKeyboardKey> _keys;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    switch (parent.side) {
      case BoardSide.left:
        _keys = [
          LogicalKeyboardKey.arrowLeft,
          LogicalKeyboardKey.keyA,
        ];
        break;
      case BoardSide.right:
        _keys = [
          LogicalKeyboardKey.arrowRight,
          LogicalKeyboardKey.keyD,
        ];
        break;
    }
  }

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!_keys.contains(event.logicalKey)) return true;

    if (event is RawKeyDownEvent) {
      parent.moveUp();
    } else if (event is RawKeyUpEvent) {
      parent.moveDown();
    }

    return false;
  }
}
