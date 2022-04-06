// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template slingshots}
/// A [Blueprint] which creates the left and right pairs of [Slingshot]s.
/// {@endtemplate}
class Slingshots extends Forge2DBlueprint {
  @override
  void build(_) {
    // TODO(allisonryan0002): use radians values instead of converting degrees.
    final leftUpperSlingshot = Slingshot(
      length: 5.66,
      angle: -1.5 * (math.pi / 180),
      spritePath: Assets.images.slingshot.leftUpper.keyName,
    )..initialPosition = Vector2(-29, 1.5);

    final leftLowerSlingshot = Slingshot(
      length: 3.54,
      angle: -29.1 * (math.pi / 180),
      spritePath: Assets.images.slingshot.leftLower.keyName,
    )..initialPosition = Vector2(-31, -6.2);

    final rightUpperSlingshot = Slingshot(
      length: 5.64,
      angle: 1 * (math.pi / 180),
      spritePath: Assets.images.slingshot.rightUpper.keyName,
    )..initialPosition = Vector2(22.3, 1.58);

    final rightLowerSlingshot = Slingshot(
      length: 3.46,
      angle: 26.8 * (math.pi / 180),
      spritePath: Assets.images.slingshot.rightLower.keyName,
    )..initialPosition = Vector2(24.7, -6.2);

    addAll([
      leftUpperSlingshot,
      leftLowerSlingshot,
      rightUpperSlingshot,
      rightLowerSlingshot,
    ]);
  }
}

/// {@template slingshot}
/// Elastic bumper that bounces the [Ball] off of its straight sides.
/// {@endtemplate}
class Slingshot extends BodyComponent with InitialPosition {
  /// {@macro slingshot}
  Slingshot({
    required double length,
    required double angle,
    required String spritePath,
  })  : _length = length,
        _angle = angle,
        _spritePath = spritePath,
        super(priority: 1);

  final double _length;

  final double _angle;

  final String _spritePath;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];
    const circleRadius = 1.55;

    final topCircleShape = CircleShape()..radius = circleRadius;
    topCircleShape.position.setValues(0, _length / 2);
    final topCircleFixtureDef = FixtureDef(topCircleShape)..friction = 0;
    fixturesDef.add(topCircleFixtureDef);

    final bottomCircleShape = CircleShape()..radius = circleRadius;
    bottomCircleShape.position.setValues(0, -_length / 2);
    final bottomCircleFixtureDef = FixtureDef(bottomCircleShape)..friction = 0;
    fixturesDef.add(bottomCircleFixtureDef);

    final leftEdgeShape = EdgeShape()
      ..set(
        Vector2(circleRadius, _length / 2),
        Vector2(circleRadius, -_length / 2),
      );
    final leftEdgeShapeFixtureDef = FixtureDef(leftEdgeShape)
      ..friction = 0
      ..restitution = 5;
    fixturesDef.add(leftEdgeShapeFixtureDef);

    final rightEdgeShape = EdgeShape()
      ..set(
        Vector2(-circleRadius, _length / 2),
        Vector2(-circleRadius, -_length / 2),
      );
    final rightEdgeShapeFixtureDef = FixtureDef(rightEdgeShape)
      ..friction = 0
      ..restitution = 5;
    fixturesDef.add(rightEdgeShapeFixtureDef);

    return fixturesDef;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()
      ..userData = this
      ..position = initialPosition
      ..angle = _angle;

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
    final sprite = await gameRef.loadSprite(_spritePath);

    await add(
      SpriteComponent(
        sprite: sprite,
        size: sprite.originalSize / 10,
        anchor: Anchor.center,
        angle: _angle,
      ),
    );
  }
}
