import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template alien_bumper_sprite_behavior}
///
/// {@endtemplate}
class SpriteBehavior extends TimerComponent with ParentIsA<SparkyBumper> {
  /// {@macro alien_bumper_sprite_behavior}
  SpriteBehavior()
      : super(
          period: 0.05,
          removeOnFinish: false,
        );

  void _onNewState(SparkyBumperState state) {
    switch (state) {
      case SparkyBumperState.active:
        timer.stop();
        break;
      case SparkyBumperState.inactive:
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
    parent.bloc.onAnimated();
  }
}
