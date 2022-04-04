import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class FireEffectGame extends LineGame {
  static const info = '''
  Shows how the FireEffect renders.

  Drag a line to define the trail direction.
''';

  @override
  void onLine(Vector2 line) {
    add(_EffectEmitter(line));
  }
}

class _EffectEmitter extends Component {
  _EffectEmitter(this.line) {
    _direction = line.normalized();
    _force = line.length;
  }

  static const _timerLimit = 2.0;
  var _timer = _timerLimit;

  final Vector2 line;

  late Vector2 _direction;
  late double _force;

  @override
  void update(double dt) {
    super.update(dt);

    if (_timer > 0) {
      add(
        FireEffect(
          burstPower: (_timer / _timerLimit) * _force,
          direction: _direction,
        ),
      );
      _timer -= dt;
    } else {
      removeFromParent();
    }
  }
}
