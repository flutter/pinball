import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template multiball_blinking_behavior}
/// Makes a [Multiball] blink back to [MultiballState.lit] when
/// [MultiballState.dimmed].
/// {@endtemplate}
class MultiballBlinkingBehavior extends TimerComponent
    with ParentIsA<Multiball> {
  /// {@macro multiball_blinking_behavior}
  MultiballBlinkingBehavior() : super(period: 0.05);

  void _onNewState(MultiballState state) {
    switch (state) {
      case MultiballState.lit:
        break;
      case MultiballState.dimmed:
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

/*
/// Animates the [Multiball].
  Future<void> animate() async {
    final spriteGroupComponent = firstChild<MultiballSpriteGroupComponent>();

    for (var i = 0; i < 5; i++) {
      spriteGroupComponent?.current = MultiballState.lit;
      await Future<void>.delayed(const Duration(milliseconds: 100));
      spriteGroupComponent?.current = MultiballState.dimmed;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
  */