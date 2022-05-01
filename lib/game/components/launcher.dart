import 'package:flame/components.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// {@template launcher}
/// A [Blueprint] which creates the [Plunger], [RocketSpriteComponent] and
/// [LaunchRamp].
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
