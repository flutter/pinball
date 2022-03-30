import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pinball/flame/flame.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template flipper_controller}
/// A [ComponentController] that controls a [Flipper]s movement.
/// {@endtemplate}
class FlipperController extends ComponentController<Flipper>
    with KeyboardHandler {
  /// {@macro flipper_controller}
  FlipperController(Flipper flipper)
      : _keys = flipper.side.flipperKeys,
        super(flipper);

  /// The [LogicalKeyboardKey]s that will control the [Flipper].
  ///
  /// [onKeyEvent] method listens to when one of these keys is pressed.
  final List<LogicalKeyboardKey> _keys;

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (!_keys.contains(event.logicalKey)) return true;

    if (event is RawKeyDownEvent) {
      component.moveUp();
    } else if (event is RawKeyUpEvent) {
      component.moveDown();
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
