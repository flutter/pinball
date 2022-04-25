import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template alien_bumper_sprite_behavior}
///
/// {@endtemplate}
class AlienBumperSpriteBehavior extends TimerComponent {
  /// {@macro alien_bumper_sprite_behavior}
  AlienBumperSpriteBehavior()
      : super(
          period: 0.05,
          removeOnFinish: false,
        );

  void _onNewState(AlienBumperState state) {
    switch (state) {
      case AlienBumperState.active:
        timer.stop();
        break;
      case AlienBumperState.inactive:
        timer
          ..reset()
          ..start();
        break;
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // TODO(alestiago): Refactor once the following is merged:
    // https://github.com/flame-engine/flame/pull/1566
    final parent = this.parent;
    if (parent is! AlienBumper) return;

    timer.stop();
    parent.stream.listen(_onNewState);
  }

  @override
  void onTick() {
    super.onTick();
    // TODO(alestiago): Refactor once the following is merged:
    // https://github.com/flame-engine/flame/pull/1566
    final parent = this.parent;
    if (parent is! AlienBumper) return;

    parent.state = AlienBumperState.active;
  }
}
