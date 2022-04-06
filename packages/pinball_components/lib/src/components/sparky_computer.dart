// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template sparky_computer}
/// A [Blueprint] which creates the [_ComputerBase] and [_ComputerTop].
/// {@endtemplate}
class SparkyComputer extends Forge2DBlueprint {
  @override
  void build(_) {
    final computerBase = _ComputerBase();
    final computerTop = _ComputerTop();

    addAll([
      computerBase,
      computerTop,
    ]);
  }
}

class _ComputerBase extends BodyComponent with InitialPosition {
  _ComputerBase();

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final leftEdge = EdgeShape()
      ..set(
        Vector2(-15.3, 46),
        Vector2(-15.7, 49.6),
      );
    final leftEdgeFixtureDef = FixtureDef(leftEdge);
    fixturesDef.add(leftEdgeFixtureDef);

    final topEdge = EdgeShape()
      ..set(
        Vector2(-15.7, 49.6),
        Vector2(-11.1, 50.6),
      );
    final topEdgeFixtureDef = FixtureDef(topEdge);
    fixturesDef.add(topEdgeFixtureDef);

    final rightEdge = EdgeShape()
      ..set(
        Vector2(-11.1, 50.6),
        Vector2(-9.4, 47.2),
      );
    final rightEdgeFixtureDef = FixtureDef(rightEdge);
    fixturesDef.add(rightEdgeFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition;

    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadSprite();
    renderBody = false;
  }

  Future<void> _loadSprite() async {
    final sprite = await gameRef.loadSprite(
      Assets.images.sparky.computer.base.keyName,
    );

    await add(
      SpriteComponent(
        sprite: sprite,
        size: sprite.originalSize / 10,
        anchor: Anchor.center,
        position: Vector2(-12.35, -48.35),
      ),
    );
  }
}

class _ComputerTop extends SpriteComponent with HasGameRef {
  _ComputerTop()
      : super(
          anchor: Anchor.center,
          position: Vector2(-12.85, -49.75),
          priority: 1,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite(
      Assets.images.sparky.computer.top.keyName,
    );
    this.sprite = sprite;
    size = sprite.originalSize / 10;
  }
}
