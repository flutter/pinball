import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template dino_desert}
/// Area located next to the [Launcher] containing the [ChromeDino] and
/// [DinoWalls].
/// {@endtemplate}
class DinoDesert extends Blueprint {
  /// {@macro dino_desert}
  DinoDesert()
      : super(
          components: [
            ChromeDino(
              children: [
                ScoringBehavior(points: 200000)..applyTo(['inside_mouth']),
              ],
            )..initialPosition = Vector2(12.3, -6.9),
            _BarrierBehindDino(),
          ],
          blueprints: [
            DinoWalls(),
          ],
        );
}

class _BarrierBehindDino extends BodyComponent {
  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(
        Vector2(27, -14.2),
        Vector2(25, -7.7),
      );

    return world.createBody(BodyDef())..createFixtureFromShape(shape);
  }
}
