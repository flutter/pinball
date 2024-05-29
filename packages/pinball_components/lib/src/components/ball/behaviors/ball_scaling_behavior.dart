import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

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

    final ballSprite = parent.descendants().whereType<SpriteComponent>();
    if (ballSprite.isNotEmpty) {
      ballSprite.single.scale.setValues(
        scaleFactor,
        scaleFactor,
      );
    }
  }
}
