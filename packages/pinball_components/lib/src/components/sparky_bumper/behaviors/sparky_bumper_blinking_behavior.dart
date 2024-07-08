import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_bumper_blinking_behavior}
/// Makes a [SparkyBumper] blink back to [SparkyBumperState.lit] when
/// [SparkyBumperState.dimmed].
/// {@endtemplate}
class SparkyBumperBlinkingBehavior extends TimerComponent
    with ParentIsA<SparkyBumper> {
  /// {@macro sparky_bumper_blinking_behavior}
  SparkyBumperBlinkingBehavior() : super(period: 0.05);

  void _onNewState(SparkyBumperState state) {
    switch (state) {
      case SparkyBumperState.lit:
        break;
      case SparkyBumperState.dimmed:
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
