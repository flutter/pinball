import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template kicker_blinking_behavior}
/// Makes a [Kicker] blink back to [KickerState.lit] when [KickerState.dimmed].
/// {@endtemplate}
class KickerBlinkingBehavior extends TimerComponent with ParentIsA<Kicker> {
  /// {@macro kicker_blinking_behavior}
  KickerBlinkingBehavior() : super(period: 0.05);

  void _onNewState(KickerState state) {
    switch (state) {
      case KickerState.lit:
        break;
      case KickerState.dimmed:
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
