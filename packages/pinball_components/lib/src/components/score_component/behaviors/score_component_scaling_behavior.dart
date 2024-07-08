import 'package:flame/components.dart';
import 'package:pinball_components/pinball_components.dart';

/// Scales a [ScoreComponent] according to its position on the board.
class ScoreComponentScalingBehavior extends Component
    with ParentIsA<SpriteComponent> {
  @override
  void update(double dt) {
    super.update(dt);
    final boardHeight = BoardDimensions.bounds.height;
    const maxShrinkValue = 0.83;

    final augmentedPosition = parent.position.y * 3;
    final standardizedYPosition = augmentedPosition + (boardHeight / 2);
    final scaleFactor = maxShrinkValue +
        ((standardizedYPosition / boardHeight) * (1 - maxShrinkValue));

    parent.scale.setValues(
      scaleFactor,
      scaleFactor,
    );
  }
}
