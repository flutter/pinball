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
    _keys = parent.side.flipperKeys;
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

extension on BoardSide {
  List<LogicalKeyboardKey> get flipperKeys {
    switch (this) {
      case BoardSide.left:
        return [
          LogicalKeyboardKey.arrowLeft,
          LogicalKeyboardKey.keyA,
        ];
      case BoardSide.right:
        return [
          LogicalKeyboardKey.arrowRight,
          LogicalKeyboardKey.keyD,
        ];
    }
  }
}
