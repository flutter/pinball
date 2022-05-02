import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template dino_desert}
/// Area located next to the [Launcher] containing the [ChromeDino] and
/// [DinoWalls].
/// {@endtemplate}
class DinoDesert extends Component {
  /// {@macro dino_desert}
  DinoDesert()
      : super(
          children: [
            ChromeDino(
              children: [
                ScoringBehavior(points: Points.twoHundredThousand)
                  ..applyTo(['inside_mouth']),
              ],
            )..initialPosition = Vector2(12.6, -6.9),
            _BarrierBehindDino(),
            DinoWalls(),
            Slingshots(),
          ],
        );
}

class _BarrierBehindDino extends BodyComponent {
  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(
        Vector2(25, -14.2),
        Vector2(25, -7.7),
      );

    return world.createBody(BodyDef())..createFixtureFromShape(shape);
  }
}
