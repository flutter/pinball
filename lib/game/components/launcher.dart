import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;
import 'package:pinball_flame/pinball_flame.dart';

/// {@template launcher}
/// A [Blueprint] which creates the [Plunger], [RocketSpriteComponent] and
/// [LaunchRamp].
/// {@endtemplate}
class Launcher extends Blueprint {
  /// {@macro launcher}
  Launcher()
      : super(
          components: [
            ControlledPlunger(compressionDistance: 14)
              ..initialPosition = Vector2(40.7, 38),
            RocketSpriteComponent()..position = Vector2(43, 62),
          ],
          blueprints: [LaunchRamp()],
        );
}
