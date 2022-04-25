import 'package:flame/components.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/game/pinball_game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template multipliers_group_component}
/// A [SpriteGroupComponent] for the multiplier over the board.
/// {@endtemplate}
class MultipliersGroup extends Component
    with Controls<_MultipliersController>, HasGameRef<PinballGame> {
  /// {@macro multipliers_group_component}
  MultipliersGroup()
      : super(
          children: [
            MultiplierSpriteGroupComponent(
              position: Vector2(-20, 0),
              onAssetPath: Assets.images.multiplier.x2.active.keyName,
              offAssetPath: Assets.images.multiplier.x2.inactive.keyName,
            ),
            MultiplierSpriteGroupComponent(
              position: Vector2(20, -5),
              onAssetPath: Assets.images.multiplier.x3.active.keyName,
              offAssetPath: Assets.images.multiplier.x3.inactive.keyName,
            ),
            MultiplierSpriteGroupComponent(
              position: Vector2(0, -15),
              onAssetPath: Assets.images.multiplier.x4.active.keyName,
              offAssetPath: Assets.images.multiplier.x4.inactive.keyName,
            ),
            MultiplierSpriteGroupComponent(
              position: Vector2(-10, -25),
              onAssetPath: Assets.images.multiplier.x5.active.keyName,
              offAssetPath: Assets.images.multiplier.x5.inactive.keyName,
            ),
            MultiplierSpriteGroupComponent(
              position: Vector2(10, -35),
              onAssetPath: Assets.images.multiplier.x6.active.keyName,
              offAssetPath: Assets.images.multiplier.x6.inactive.keyName,
            ),
          ],
        );
}

class _MultipliersController extends ComponentController<MultipliersGroup>
    with HasGameRef<PinballGame> {
  _MultipliersController(MultipliersGroup multipliersGroup)
      : super(multipliersGroup);
}
