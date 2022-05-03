import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Scales the ball's body and sprite according to its position on the board.
class BallScalingBehavior extends Component with ParentIsA<Ball> {
  @override
  void update(double dt) {
    super.update(dt);
    final boardHeight = BoardDimensions.bounds.height;
    const maxShrinkValue = BoardDimensions.perspectiveShrinkFactor;

    final standardizedYPosition = parent.body.position.y + (boardHeight / 2);
    final scaleFactor = maxShrinkValue +
        ((standardizedYPosition / boardHeight) * (1 - maxShrinkValue));

    parent.body.fixtures.first.shape.radius = (Ball.size.x / 2) * scaleFactor;

    parent.firstChild<SpriteComponent>()!.scale.setValues(
          scaleFactor,
          scaleFactor,
        );
  }
}
