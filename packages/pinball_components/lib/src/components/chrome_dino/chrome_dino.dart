import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Timer;
import 'package:flutter/material.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/chrome_dino/behaviors/behaviors.dart';
import 'package:pinball_flame/pinball_flame.dart';

export 'cubit/chrome_dino_cubit.dart';

/// {@template chrome_dino}
/// Dino that swivels back and forth, opening its mouth to eat a [Ball].
///
/// Upon eating a [Ball], the dino rotates and spits the [Ball] out in the
/// opposite direction.
/// {@endtemplate}
class ChromeDino extends BodyComponent
    with InitialPosition, ContactCallbacks, ZIndex {
  /// {@macro chrome_dino}
  ChromeDino({Iterable<Component>? children})
      : bloc = ChromeDinoCubit(),
        super(
          children: [
            _ChromeDinoMouthSprite(),
            _ChromeDinoHeadSprite(),
            ChromeDinoMouthOpeningBehavior()..applyTo(['mouth_opening']),
            ChromeDinoSwivelingBehavior(),
            ChromeDinoChompingBehavior()..applyTo(['inside_mouth']),
            ChromeDinoSpittingBehavior(),
            ...?children,
          ],
          renderBody: false,
        ) {
    zIndex = ZIndexes.dino;
  }

  /// Creates a [ChromeDino] without any children.
  ///
  /// This can be used for testing [ChromeDino]'s behaviors in isolation.
  @visibleForTesting
  ChromeDino.test({
    required this.bloc,
  });

  // ignore: public_member_api_docs
  final ChromeDinoCubit bloc;

  /// Angle to rotate the dino up or down from the starting horizontal position.
  static const halfSweepingAngle = 0.1143;

  @override
  void onRemove() {
    bloc.close();
    super.onRemove();
  }

  List<FixtureDef> _createFixtureDefs() {
    const mouthAngle = -(halfSweepingAngle + 0.28);
    final size = Vector2(6, 6);

    final topEdge = PolygonShape()
      ..setAsBox(
        size.x / 2,
        0.1,
        initialPosition + Vector2(-4, -1.4),
        mouthAngle,
      );
    final topEdgeFixtureDef = FixtureDef(topEdge, density: 100);

    final backEdge = PolygonShape()
      ..setAsBox(
        0.1,
        size.y / 2,
        initialPosition + Vector2(-1, 0.5),
        -halfSweepingAngle,
      );
    final backEdgeFixtureDef = FixtureDef(backEdge, density: 100);

    final bottomEdge = PolygonShape()
      ..setAsBox(
        size.x / 2,
        0.1,
        initialPosition + Vector2(-3.3, 4.7),
        mouthAngle,
      );
    final bottomEdgeFixtureDef = FixtureDef(
      bottomEdge,
      density: 100,
    );

    final mouthOpeningEdge = PolygonShape()
      ..setAsBox(
        0.1,
        size.y / 2.5,
        initialPosition + Vector2(-6.4, 2.7),
        -halfSweepingAngle,
      );
    final mouthOpeningEdgeFixtureDef = FixtureDef(
      mouthOpeningEdge,
      density: 0.1,
      userData: 'mouth_opening',
    );

    final insideSensor = PolygonShape()
      ..setAsBox(
        0.2,
        0.2,
        initialPosition + Vector2(-3, 1.5),
        0,
      );
    final insideSensorFixtureDef = FixtureDef(
      insideSensor,
      isSensor: true,
      userData: 'inside_mouth',
    );

    return [
      topEdgeFixtureDef,
      backEdgeFixtureDef,
      bottomEdgeFixtureDef,
      mouthOpeningEdgeFixtureDef,
      insideSensorFixtureDef,
    ];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: initialPosition,
      type: BodyType.dynamic,
      gravityScale: Vector2.zero(),
    );
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }
}

class _ChromeDinoMouthSprite extends SpriteAnimationComponent with HasGameRef {
  _ChromeDinoMouthSprite()
      : super(
          anchor: Anchor(Anchor.center.x + 0.47, Anchor.center.y - 0.29),
          angle: ChromeDino.halfSweepingAngle,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = gameRef.images.fromCache(
      Assets.images.dino.animatronic.mouth.keyName,
    );

    const amountPerRow = 11;
    const amountPerColumn = 9;
    final textureSize = Vector2(
      image.width / amountPerRow,
      image.height / amountPerColumn,
    );
    size = textureSize / 10;

    final data = SpriteAnimationData.sequenced(
      amount: (amountPerColumn * amountPerRow) - 1,
      amountPerRow: amountPerRow,
      stepTime: 1 / 24,
      textureSize: textureSize,
    );
    animation = SpriteAnimation.fromFrameData(image, data);
  }
}

class _ChromeDinoHeadSprite extends SpriteAnimationComponent with HasGameRef {
  _ChromeDinoHeadSprite()
      : super(
          anchor: Anchor(Anchor.center.x + 0.47, Anchor.center.y - 0.29),
          angle: ChromeDino.halfSweepingAngle,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final image = gameRef.images.fromCache(
      Assets.images.dino.animatronic.head.keyName,
    );

    const amountPerRow = 11;
    const amountPerColumn = 9;
    final textureSize = Vector2(
      image.width / amountPerRow,
      image.height / amountPerColumn,
    );
    size = textureSize / 10;

    final data = SpriteAnimationData.sequenced(
      amount: (amountPerColumn * amountPerRow) - 1,
      amountPerRow: amountPerRow,
      stepTime: 1 / 24,
      textureSize: textureSize,
    );
    animation = SpriteAnimation.fromFrameData(image, data);
  }
}
