import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template android_bumper_blinking_behavior}
/// Makes an [AndroidBumper] blink back to [AndroidBumperState.lit] when
/// [AndroidBumperState.dimmed].
/// {@endtemplate}
class AndroidBumperBlinkingBehavior extends TimerComponent
    with ParentIsA<AndroidBumper> {
  /// {@macro android_bumper_blinking_behavior}
  AndroidBumperBlinkingBehavior() : super(period: 0.05);

  void _onNewState(AndroidBumperState state) {
    switch (state) {
      case AndroidBumperState.lit:
        break;
      case AndroidBumperState.dimmed:
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
