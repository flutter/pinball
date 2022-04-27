import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template sparky_bumper_blinking_behavior}
/// Makes a [SparkyBumper] blink back to [SparkyBumperState.active] when
/// [SparkyBumperState.inactive].
/// {@endtemplate}
class SparkyBumperBlinkingBehavior extends TimerComponent
    with ParentIsA<SparkyBumper> {
  /// {@macro sparky_bumper_sprite_behavior}
  SparkyBumperBlinkingBehavior() : super(period: 0.05);

  void _onNewState(SparkyBumperState state) {
    switch (state) {
      case SparkyBumperState.active:
        break;
      case SparkyBumperState.inactive:
        timer
          ..reset()
          ..start();
        break;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    timer.stop();
    parent.bloc.stream.listen(_onNewState);
  }

  @override
  void onTick() {
    super.onTick();
    timer.stop();
    parent.bloc.onBlinked();
  }
}
