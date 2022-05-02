import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart' hide Timer;
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template chrome_dino}
/// Dino that swivels back and forth, opening its mouth to eat a [Ball].
///
/// Upon eating a [Ball], the dino rotates and spits the [Ball] out in a
/// different direction.
/// {@endtemplate}
class ChromeDino extends BodyComponent with InitialPosition, ZIndex {
  /// {@macro chrome_dino}
  ChromeDino()
      : super(
          renderBody: false,
        ) {
    zIndex = ZIndexes.dino;
  }

  /// The size of the dinosaur mouth.
  static final size = Vector2(5.5, 5);

  /// Anchors the [ChromeDino] to the [RevoluteJoint] that controls its arc
  /// motion.
  Future<_ChromeDinoJoint> _anchorToJoint() async {
    // TODO(allisonryan0002): try moving to anchor after new body is defined.
    final anchor = _ChromeDinoAnchor()
      ..initialPosition = initialPosition + Vector2(9, -4);

    await add(anchor);

    final jointDef = _ChromeDinoAnchorRevoluteJointDef(
      chromeDino: this,
      anchor: anchor,
    );
    final joint = _ChromeDinoJoint(jointDef);
    world.createJoint(joint);

    return joint;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final joint = await _anchorToJoint();
    const framesInAnimation = 98;
    const animationFPS = 1 / 24;
    await add(
      TimerComponent(
        period: (framesInAnimation / 2) * animationFPS,
        onTick: joint._swivel,
        repeat: true,
      ),
    );
  }

  List<FixtureDef> _createFixtureDefs() {
    final fixtureDefs = <FixtureDef>[];

    // TODO(allisonryan0002): Update this shape to better match sprite.
    final box = PolygonShape()
      ..setAsBox(
        size.x / 2,
        size.y / 2,
        initialPosition + Vector2(-4, 2),
        -_ChromeDinoJoint._halfSweepingAngle,
      );
    final fixtureDef = FixtureDef(box, density: 1);
    fixtureDefs.add(fixtureDef);

    return fixtureDefs;
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

class _ChromeDinoAnchor extends JointAnchor {
  _ChromeDinoAnchor();

  // TODO(allisonryan0002): if these aren't moved when fixing the rendering, see
  // if the joint can be created in onMount to resolve render syncing.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await addAll([
      _ChromeDinoMouthSprite(),
      _ChromeDinoHeadSprite(),
    ]);
  }
}

/// {@template chrome_dino_anchor_revolute_joint_def}
/// Hinges a [ChromeDino] to a [_ChromeDinoAnchor].
/// {@endtemplate}
class _ChromeDinoAnchorRevoluteJointDef extends RevoluteJointDef {
  /// {@macro chrome_dino_anchor_revolute_joint_def}
  _ChromeDinoAnchorRevoluteJointDef({
    required ChromeDino chromeDino,
    required _ChromeDinoAnchor anchor,
  }) {
    initialize(
      chromeDino.body,
      anchor.body,
      chromeDino.body.position + anchor.body.position,
    );
    enableLimit = true;
    lowerAngle = -_ChromeDinoJoint._halfSweepingAngle;
    upperAngle = _ChromeDinoJoint._halfSweepingAngle;

    enableMotor = true;
    maxMotorTorque = chromeDino.body.mass * 255;
    motorSpeed = 2;
  }
}

class _ChromeDinoJoint extends RevoluteJoint {
  _ChromeDinoJoint(_ChromeDinoAnchorRevoluteJointDef def) : super(def);

  static const _halfSweepingAngle = 0.1143;

  /// Sweeps the [ChromeDino] up and down repeatedly.
  void _swivel() {
    setMotorSpeed(-motorSpeed);
  }
}

class _ChromeDinoMouthSprite extends SpriteAnimationComponent with HasGameRef {
  _ChromeDinoMouthSprite()
      : super(
          anchor: Anchor(Anchor.center.x + 0.47, Anchor.center.y - 0.29),
          angle: _ChromeDinoJoint._halfSweepingAngle,
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
    animation = SpriteAnimation.fromFrameData(image, data)..currentIndex = 45;
  }
}

class _ChromeDinoHeadSprite extends SpriteAnimationComponent with HasGameRef {
  _ChromeDinoHeadSprite()
      : super(
          anchor: Anchor(Anchor.center.x + 0.47, Anchor.center.y - 0.29),
          angle: _ChromeDinoJoint._halfSweepingAngle,
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
    animation = SpriteAnimation.fromFrameData(image, data)..currentIndex = 45;
  }
}
