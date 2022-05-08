import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ramp_arrow_blinking_behavior}
/// Makes a [SpaceshipRampArrowSpriteComponent] blink between
/// [ArrowLightState.values].
/// {@endtemplate}
class RampArrowBlinkingBehavior extends TimerComponent
    with ParentIsA<SpaceshipRamp> {
  /// {@macro ramp_arrow_blinking_behavior}
  RampArrowBlinkingBehavior() : super(period: 0.05);

  final _maxBlinks = 20;

  int _blinksCounter = 0;

  bool _isAnimating = false;

  void _onNewState(SpaceshipRampState state) {
    final animationEnabled =
        state.animationState == ArrowAnimationState.blinking;
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
    readBloc<SpaceshipRampCubit, SpaceshipRampState>().onBlink();
    _blinksCounter++;
  }

  void _stop() {
    if (_isAnimating) {
      _isAnimating = false;
      timer.stop();
      _blinksCounter = 0;
      readBloc<SpaceshipRampCubit, SpaceshipRampState>().onStop();
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      FlameBlocListener<SpaceshipRampCubit, SpaceshipRampState>(
        onNewState: _onNewState,
      ),
    );
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
