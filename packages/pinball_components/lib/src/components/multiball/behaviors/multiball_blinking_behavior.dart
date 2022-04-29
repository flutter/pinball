import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template multiball_blinking_behavior}
/// Makes a [Multiball] blink back to [MultiballLightState.lit] when
/// [MultiballLightState.dimmed].
/// {@endtemplate}
class MultiballBlinkingBehavior extends TimerComponent
    with ParentIsA<Multiball> {
  /// {@macro multiball_blinking_behavior}
  MultiballBlinkingBehavior() : super(period: 0.5);

  final _maxBlinks = 5;
  int _blinkCounter = 0;

  void _onNewState(MultiballState state) {
    if (state.animationState == MultiballAnimationState.animated) {
      _animate();
      if (!timer.isRunning()) {
        timer
          ..reset()
          ..start();
      }
    } else {
      timer.stop();
      parent.bloc.onStop();
    }
  }

  void _animate() {
    if (_blinkCounter <= _maxBlinks) {
      _blinkCounter++;
      print("onBlink");
      parent.bloc.onBlink();
    } else {
      print("onStop");
      parent.bloc.onStop();
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen(_onNewState);
  }

  @override
  void onTick() {
    super.onTick();
    timer
      ..reset()
      ..start();
  }
}
