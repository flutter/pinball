import 'package:flame/components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template animatronic_looping_behavior}
/// Behavior that can be added to a [SpriteAnimationComponent] to repeatedly
/// trigger its animation at a set interval.
/// {@endtemplate}
class AnimatronicLoopingBehavior extends TimerComponent
    with ParentIsA<SpriteAnimationComponent> {
  /// {@macro animatronic_looping_behavior}
  AnimatronicLoopingBehavior({
    required double animationCoolDown,
  }) : super(period: animationCoolDown);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.animation?.onComplete = () {
      parent.animation?.reset();
      parent.playing = false;
      timer
        ..reset()
        ..start();
    };
  }

  @override
  void onTick() {
    parent.playing = true;
  }
}
