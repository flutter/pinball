import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template ball_impulsing_behavior}
/// Impulses the [Ball] in a given direction.
/// {@endtemplate}
class BallImpulsingBehavior extends Component with ParentIsA<Ball> {
  /// {@macro ball_impulsing_behavior}
  BallImpulsingBehavior({
    required Vector2 impulse,
  }) : _impulse = impulse;

  final Vector2 _impulse;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    parent.body.linearVelocity = _impulse;
    shouldRemove = true;
  }
}
