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
  MultiballBlinkingBehavior() : super(period: 0.01);

  final _maxBlinks = 10;
  int _blinksCounter = 0;
  bool _isAnimating = false;

  void _onNewState(MultiballState state) {
    final animationEnabled =
        state.animationState == MultiballAnimationState.animated;
    final canBlink = _blinksCounter < _maxBlinks;
    if (animationEnabled && canBlink) {
      _animate();
    } else {
      _stop();
    }
  }

  Future<void> _animate() async {
    if (!_isAnimating) {
      _isAnimating = true;
      parent.bloc.onBlink();
      _blinksCounter++;
    }
  }

  void _stop() {
    if (_isAnimating) {
      _isAnimating = false;
      timer.stop();
      _blinksCounter = 0;
      parent.bloc.onStop();
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
    if (_isAnimating) {
      timer
        ..reset()
        ..start();
    } else {
      timer.stop();
    }
  }
}
