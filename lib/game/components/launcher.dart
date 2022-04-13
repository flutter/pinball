import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template launcher}
/// A [Blueprint] which creates the [Plunger], [RocketSpriteComponent] and
/// [LaunchRamp].
/// {@endtemplate}
class Launcher extends Forge2DBlueprint {
  /// {@macro launcher}
  Launcher();

  /// [Plunger] to launch the [Ball] onto the board.
  late final Plunger plunger;

  @override
  void build(Forge2DGame gameRef) {
    plunger = ControlledPlunger(compressionDistance: 12.3)
      ..initialPosition = Vector2(40.1, 38);

    final _rocket = RocketSpriteComponent()..position = Vector2(43, 62);

    addAll([_rocket, plunger]);
    addBlueprint(LaunchRamp());
  }
}
