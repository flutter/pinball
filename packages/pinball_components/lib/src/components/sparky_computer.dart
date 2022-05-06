// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template sparky_computer}
/// A computer owned by Sparky.
/// {@endtemplate}
class SparkyComputer extends Component {
  /// {@macro sparky_computer}
  SparkyComputer()
      : super(
          children: [
            _ComputerBase(),
            _ComputerTopSpriteComponent(),
            _ComputerGlowSpriteComponent(),
          ],
        );
}

class _ComputerBase extends BodyComponent with InitialPosition, ZIndex {
  _ComputerBase()
      : super(
          renderBody: false,
          children: [_ComputerBaseSpriteComponent()],
        ) {
    zIndex = ZIndexes.computerBase;
  }

  List<FixtureDef> _createFixtureDefs() {
    final leftEdge = EdgeShape()
      ..set(
        Vector2(-15.3, -45.9),
        Vector2(-15.7, -49.5),
      );
    final topEdge = EdgeShape()
      ..set(
        leftEdge.vertex2,
        Vector2(-11.1, -50.5),
      );
    final rightEdge = EdgeShape()
      ..set(
        topEdge.vertex2,
        Vector2(-9.4, -47.1),
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
          position: Vector2(-12.44, -48.15),
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

class _ComputerTopSpriteComponent extends SpriteComponent
    with HasGameRef, ZIndex {
  _ComputerTopSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-12.86, -49.37),
        ) {
    zIndex = ZIndexes.computerTop;
  }

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

class _ComputerGlowSpriteComponent extends SpriteComponent
    with HasGameRef, ZIndex {
  _ComputerGlowSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(4, 11),
        ) {
    zIndex = ZIndexes.computerGlow;
  }

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
