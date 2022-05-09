import 'package:flame/components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class AnimatronicLoopingBehavior extends TimerComponent
    with ParentIsA<SpriteAnimationComponent> {
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
