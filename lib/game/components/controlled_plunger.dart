import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template controlled_plunger}
/// A [Plunger] with a [PlungerController] attached.
/// {@endtemplate}
class ControlledPlunger extends Plunger with Controls<PlungerController> {
  /// {@macro controlled_plunger}
  ControlledPlunger({required double compressionDistance})
      : super(compressionDistance: compressionDistance) {
    controller = PlungerController(this);
  }

  @override
  void release() {
    super.release();

    add(PlungerNoiseBehavior());
  }
}

/// A behavior attached to the plunger when it launches the ball which plays the
/// related sound effects.
class PlungerNoiseBehavior extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    readProvider<PinballPlayer>().play(PinballAudio.launcher);
  }

  @override
  void update(double dt) {
    super.update(dt);
    removeFromParent();
  }
}

/// {@template plunger_controller}
/// A [ComponentController] that controls a [Plunger]s movement.
/// {@endtemplate}
class PlungerController extends ComponentController<Plunger>
    with KeyboardHandler, FlameBlocReader<GameBloc, GameState> {
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
    if (bloc.state.status.isGameOver) return true;
    if (!_keys.contains(event.logicalKey)) return true;

    if (event is RawKeyDownEvent) {
      component.pull();
    } else if (event is RawKeyUpEvent) {
      component.release();
    }

    return false;
  }
}
