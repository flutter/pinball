import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/components/components.dart';
import 'package:pinball/gen/assets.gen.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template plunger_zone}
/// A [Blueprint] which creates zone for the [Plunger].
/// {@endtemplate}
class PlungerZone extends Forge2DBlueprint {
  /// {@macro plunger_zone}
  PlungerZone();

  late final Plunger plunger;

  @override
  void build(Forge2DGame gameRef) {
    plunger = ControlledPlunger(compressionDistance: 12.3)
      ..initialPosition = Vector2(40.1, -38);

    final _rocket = _PlungerRocketSpriteComponent();

    addAll([_rocket, plunger]);
  }
}

class _PlungerRocketSpriteComponent extends SpriteComponent with HasGameRef {
  _PlungerRocketSpriteComponent() : super(priority: 5);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = await gameRef.loadSprite(
      Assets.images.components.rocket.path,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
    anchor = Anchor.center;
    position = Vector2(43.5, 62);
  }
}
