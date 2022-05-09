import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:pinball_components/pinball_components.dart';

/// Allows controlling the [Flipper]'s movement with keyboard input.
class FlipperKeyControllingBehavior extends Component
    with KeyboardHandler, FlameBlocReader<FlipperCubit, FlipperState> {
  /// The [LogicalKeyboardKey]s that will control the [Flipper].
  ///
  /// [onKeyEvent] method listens to when one of these keys is pressed.
  late final List<LogicalKeyboardKey> _keys;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final flipper = parent!.parent! as Flipper;
    switch (flipper.side) {
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
      bloc.moveUp();
    } else if (event is RawKeyUpEvent) {
      bloc.moveDown();
    }

    return false;
  }
}
