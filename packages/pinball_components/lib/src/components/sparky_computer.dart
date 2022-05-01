// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template sparky_computer}
/// A computer owned by Sparky.
/// {@endtemplate}
class SparkyComputer extends Blueprint {
  /// {@macro sparky_computer}
  SparkyComputer()
      : super(
          components: [
            _ComputerBase(),
            _ComputerTopSpriteComponent(),
            _ComputerGlowSpriteComponent(),
          ],
        );
}

class _ComputerBase extends BodyComponent with InitialPosition {
  _ComputerBase()
      : super(
          priority: RenderPriority.computerBase,
          renderBody: false,
          children: [_ComputerBaseSpriteComponent()],
        );

  List<FixtureDef> _createFixtureDefs() {
    final leftEdge = EdgeShape()
      ..set(
        Vector2(-14.9, -46),
        Vector2(-15.3, -49.6),
      );
    final topEdge = EdgeShape()
      ..set(
        Vector2(-15.3, -49.6),
        Vector2(-10.7, -50.6),
      );
    final rightEdge = EdgeShape()
      ..set(
        Vector2(-10.7, -50.6),
        Vector2(-9, -47.2),
      );

    return [
      FixtureDef(leftEdge),
      FixtureDef(topEdge),
      FixtureDef(rightEdge),
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(position: initialPosition);
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _ComputerBaseSpriteComponent extends SpriteComponent with HasGameRef {
  _ComputerBaseSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-12.1, -48.15),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.sparky.computer.base.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _ComputerTopSpriteComponent extends SpriteComponent with HasGameRef {
  _ComputerTopSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-12.52, -49.37),
          priority: RenderPriority.computerTop,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.sparky.computer.top.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}

class _ComputerGlowSpriteComponent extends SpriteComponent with HasGameRef {
  _ComputerGlowSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(7.4, 10),
          priority: RenderPriority.computerGlow,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.sparky.computer.glow.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
