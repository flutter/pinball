import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template alien_bumper_blinking_behavior}
/// Makes a [AlienBumper] blink back to [AlienBumperState.active] when
/// [AlienBumperState.inactive].
/// {@endtemplate}
class AlienBumperBlinkingBehavior extends TimerComponent
    with ParentIsA<AlienBumper> {
  /// {@macro alien_bumper_blinking_behavior}
  AlienBumperBlinkingBehavior() : super(period: 0.05);

  void _onNewState(AlienBumperState state) {
    switch (state) {
      case AlienBumperState.active:
        break;
      case AlienBumperState.inactive:
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
