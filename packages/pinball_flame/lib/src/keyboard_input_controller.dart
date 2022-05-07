import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

/// The signature for a key handle function
typedef KeyHandlerCallback = bool Function();

/// {@template keyboard_input_controller}
/// A [Component] that receives keyboard input and executes registered methods.
/// {@endtemplate}
class KeyboardInputController extends Component with KeyboardHandler {
  /// {@macro keyboard_input_controller}
  KeyboardInputController({
    Map<LogicalKeyboardKey, KeyHandlerCallback> keyUp = const {},
    Map<LogicalKeyboardKey, KeyHandlerCallback> keyDown = const {},
  })  : _keyUp = keyUp,
        _keyDown = keyDown;

  final Map<LogicalKeyboardKey, KeyHandlerCallback> _keyUp;
  final Map<LogicalKeyboardKey, KeyHandlerCallback> _keyDown;

  /// Trigger a virtual key up event.
  bool onVirtualKeyUp(LogicalKeyboardKey key) {
    final handler = _keyUp[key];

    if (handler != null) {
      return handler();
    }

    return true;
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isUp = event is RawKeyUpEvent;

    final handlers = isUp ? _keyUp : _keyDown;
    final handler = handlers[event.logicalKey];

    if (handler != null) {
      return handler();
    }

    return true;
  }
}

/// Add the ability to virtually trigger key events to a [FlameGame]'s
/// [KeyboardInputController].
extension VirtualKeyEvents on FlameGame {
  /// Trigger a key up
  void triggerVirtualKeyUp(LogicalKeyboardKey key) {
    final keyControllers = descendants().whereType<KeyboardInputController>();

    for (final controller in keyControllers) {
      if (!controller.onVirtualKeyUp(key)) {
        break;
      }
    }
  }
}
