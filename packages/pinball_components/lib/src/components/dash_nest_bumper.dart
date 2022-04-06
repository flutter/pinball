import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template big_dash_nest_bumper}
/// Bumper with a Dash above it.
/// {@endtemplate}
class BigDashNestBumper extends Bumper {
  /// {@macro big_dash_nest_bumper}
  BigDashNestBumper()
      : super(
          activeAssetPath: Assets.images.dashBumper.main.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.main.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0, -0.3),
          ),
        );

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: 5.1,
      minorRadius: 3.75,
    )..rotate(math.pi / 2.1);
    final fixtureDef = FixtureDef(shape);

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template small_dash_nest_bumper}
/// Bumper with a nest appearance.
/// {@endtemplate}
class SmallDashNestBumper extends Bumper {
  /// {@macro small_dash_nest_bumper}
  SmallDashNestBumper._({
    required String activeAssetPath,
    required String inactiveAssetPath,
    required SpriteComponent spriteComponent,
  }) : super(
          activeAssetPath: activeAssetPath,
          inactiveAssetPath: inactiveAssetPath,
          spriteComponent: spriteComponent,
        );

  /// {@macro small_dash_nest_bumper}
  SmallDashNestBumper.a()
      : this._(
          activeAssetPath: Assets.images.dashBumper.a.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.a.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0.35, -1.2),
          ),
        );

  /// {@macro small_dash_nest_bumper}
  SmallDashNestBumper.b()
      : this._(
          activeAssetPath: Assets.images.dashBumper.b.active.keyName,
          inactiveAssetPath: Assets.images.dashBumper.b.inactive.keyName,
          spriteComponent: SpriteComponent(
            anchor: Anchor.center,
            position: Vector2(0.35, -1.2),
          ),
        );

  @override
  Body createBody() {
    final shape = EllipseShape(
      center: Vector2.zero(),
      majorRadius: 3,
      minorRadius: 2.25,
    )..rotate(math.pi / 2);
    final fixtureDef = FixtureDef(shape)
      ..friction = 0
      ..restitution = 4;

    final bodyDef = BodyDef()
      ..position = initialPosition
      ..userData = this;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
