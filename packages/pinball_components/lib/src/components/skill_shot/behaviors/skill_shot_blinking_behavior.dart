import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template skill_shot_blinking_behavior}
/// Makes a [SkillShot] blink between [SkillShotSpriteState.lit] and
/// [SkillShotSpriteState.dimmed] for a set amount of blinks.
/// {@endtemplate}
class SkillShotBlinkingBehavior extends TimerComponent
    with ParentIsA<SkillShot> {
  /// {@macro skill_shot_blinking_behavior}
  SkillShotBlinkingBehavior() : super(period: 0.15);

  final _maxBlinks = 4;
  int _blinks = 0;

  void _onNewState(SkillShotState state) {
    if (state.isBlinking) {
      timer
        ..reset()
        ..start();
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
    if (_blinks != _maxBlinks * 2) {
      parent.bloc.switched();
      _blinks++;
    } else {
      _blinks = 0;
      timer.stop();
      parent.bloc.onBlinkingFinished();
    }
  }
}
