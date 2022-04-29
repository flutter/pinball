import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template multiball_blinking_behavior}
/// Makes a [Multiball] blink back to [MultiballLightState.lit] when
/// [MultiballLightState.dimmed].
/// {@endtemplate}
class MultiballBlinkingBehavior extends Component with ParentIsA<Multiball> {
  /// {@macro multiball_blinking_behavior}
  MultiballBlinkingBehavior() : super();

  final _maxBlinks = 10;
  bool _isAnimating = false;

  void _onNewState(MultiballState state) {
    if (state.animationState == MultiballAnimationState.animated) {
      _animate();
    } else {
      _stop();
    }
  }

  // TODO(ruimiguel): try to improve with TimerComponent?
  Future<void> _animate() async {
    if (!_isAnimating) {
      _isAnimating = true;
      for (var i = 0; i < _maxBlinks; i++) {
        parent.bloc.onBlink();
        await Future<void>.delayed(
          const Duration(milliseconds: 100),
        );
        parent.bloc.onBlink();
        await Future<void>.delayed(
          const Duration(milliseconds: 100),
        );
      }
      _stop();
    }
  }

  void _stop() {
    _isAnimating = false;
    parent.bloc.onStop();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.bloc.stream.listen(_onNewState);
  }
}
