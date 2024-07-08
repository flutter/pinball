import 'package:flame/components.dart';

class AnimatronicLoopingBehavior extends TimerComponent
    with ParentIsA<SpriteAnimationComponent> {
  AnimatronicLoopingBehavior({
    required double animationCoolDown,
  }) : super(period: animationCoolDown);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.animationTicker?.onComplete = () {
      parent.animationTicker?.reset();
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
