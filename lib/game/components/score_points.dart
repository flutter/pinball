import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template score_points}
/// Specifies the amount of points received on [Ball] collision.
/// {@endtemplate}
mixin ScorePoints<T extends Forge2DGame> on BodyComponent<T> {
  /// {@macro score_points}
  int get points;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    body.userData = this;
  }
}
