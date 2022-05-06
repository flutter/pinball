import 'package:flame/components.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template launcher}
/// Channel on the right side of the board containing the [LaunchRamp],
/// [Plunger], and [RocketSpriteComponent].
/// {@endtemplate}
class Launcher extends Component {
  /// {@macro launcher}
  Launcher()
      : super(
          children: [
            LaunchRamp(),
            Flapper(),
            ControlledPlunger(compressionDistance: 9.2)
              ..initialPosition = Vector2(41, 43.7),
            RocketSpriteComponent()..position = Vector2(42.8, 62.3),
          ],
        );
}
