import 'package:flame/components.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template launcher}
/// Section where the ball is launched from.
/// {@endtemplate}
class Launcher extends Component {
  /// {@macro launcher}
  Launcher()
      : super(
          children: [
            LaunchRamp(),
            ControlledPlunger(compressionDistance: 10.5)
              ..initialPosition = Vector2(41.1, 43),
            RocketSpriteComponent()..position = Vector2(43, 62.3),
          ],
        );
}
