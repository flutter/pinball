import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template controlled_flipper}
/// A [Flipper] with a [FlipperController] attached.
/// {@endtemplate}
class ControlledFlipper extends Flipper with Controls<FlipperController> {
  /// {@macro controlled_flipper}
  ControlledFlipper({
    required BoardSide side,
  }) : super(side: side) {
    controller = FlipperController(this);
  }
}

/// {@template flipper_controller}
/// A [ComponentController] that controls a [Flipper]s movement.
/// {@endtemplate}
class FlipperController extends ComponentController<Flipper>
    with KeyboardHandler, BlocComponent<GameBloc, GameState> {
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
    if (state?.isGameOver ?? false) return true;
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
