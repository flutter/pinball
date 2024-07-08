import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template chrome_dino_spitting_behavior}
/// Spits the [Ball] from the [ChromeDino] the next time the mouth opens.
/// {@endtemplate}
class ChromeDinoSpittingBehavior extends Component
    with ContactCallbacks, ParentIsA<ChromeDino> {
  bool _waitingForSwivel = true;

  void _onNewState(ChromeDinoState state) {
    if (state.status == ChromeDinoStatus.chomping) {
      if (state.isMouthOpen && !_waitingForSwivel) {
        add(
          TimerComponent(
            period: 0.4,
            onTick: _spit,
            removeOnFinish: true,
          ),
        );
        _waitingForSwivel = true;
      }
      if (_waitingForSwivel && !state.isMouthOpen) {
        _waitingForSwivel = false;
      }
    }
  }

  void _spit() {
    parent.bloc.state.ball!
      ..descendants().whereType<SpriteComponent>().single.setOpacity(1)
      ..body.linearVelocity = Vector2(-50, 0);
    parent.bloc.onSpit();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    parent.bloc.stream.listen(_onNewState);
  }
}
