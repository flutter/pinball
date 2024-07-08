import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template multiball_blinking_behavior}
/// Makes a [Multiball] blink back to [MultiballLightState.lit] when
/// [MultiballLightState.dimmed].
/// {@endtemplate}
class MultiballBlinkingBehavior extends TimerComponent
    with ParentIsA<Multiball> {
  /// {@macro multiball_blinking_behavior}
  MultiballBlinkingBehavior() : super(period: 0.18);

  final _maxBlinks = 28;

  int _blinksCounter = 0;

  bool _isAnimating = false;

  void _onNewState(MultiballState state) {
    final animationEnabled =
        state.animationState == MultiballAnimationState.blinking;
    final canBlink = _blinksCounter < _maxBlinks;

    if (animationEnabled && canBlink) {
      _start();
    } else {
      _stop();
    }
  }

  void _start() {
    if (!_isAnimating) {
      _isAnimating = true;
      timer
        ..reset()
        ..start();
      _animate();
    }
  }

  void _animate() {
    parent.bloc.onBlink();
    _blinksCounter++;
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
    parent.bloc.stream.listen(_onNewState);
  }

  @override
  void onTick() {
    super.onTick();
    if (!_isAnimating) {
      timer.stop();
    } else {
      if (_blinksCounter < _maxBlinks) {
        _animate();
        timer
          ..reset()
          ..start();
      } else {
        timer.stop();
      }
    }
  }
}
