// ignore_for_file: avoid_renaming_method_parameters

import 'dart:math' as math;
import 'dart:ui';

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/flame/blueprint.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';

/// A [Blueprint] for the spaceship exit rail.
class SpaceshipExitRail extends Forge2DBlueprint {
  @override
  void build(_) {
    final position = Vector2(
      PinballGame.boardBounds.left + 17.5,
      PinballGame.boardBounds.center.dy + 26,
    );

    addAllContactCallback([
      SpaceshipExitRailEndBallContactCallback(),
    ]);

    final spaceshipExitRailTopRamp = _SpaceshipExitRailTopRamp()
      ..initialPosition = position;
    final spaceshipExitRailBottomRamp = _SpaceshipExitRailBottomRamp()
      ..initialPosition = position + Vector2(2.5, -29.5);
    final exitRail = SpaceshipExitRailEnd()
      ..initialPosition = position + Vector2(7.5, -60);

    addAll([
      spaceshipExitRailTopRamp,
      spaceshipExitRailBottomRamp,
      exitRail,
    ]);
  }
}

/// {@template jetpack_ramp}
/// Represents the upper left blue ramp of the [Board].
/// {@endtemplate}
class _SpaceshipExitRailTopRamp extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipExitRailTopRamp() : super(priority: 2) {
    layer = Layer.spaceshipExitRail;
    paint = Paint()
      ..color = const Color.fromARGB(255, 185, 188, 189)
      ..style = PaintingStyle.stroke;
  }

  /// Width between walls of the ramp.
  static const width = 5.0;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final leftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(0, 0),
        Vector2(15, 0),
        Vector2(20, 10),
        Vector2(30, 10),
      ],
    )..rotate(275 * math.pi / 180);
    final leftFixtureDef = FixtureDef(leftCurveShape);
    fixturesDef.add(leftFixtureDef);

    final rightCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(0, 0 + width),
        Vector2(15, 0 + width),
        Vector2(20, 10 + width),
        Vector2(30, 10 + width),
      ],
    )..rotate(275 * math.pi / 180);
    final rightFixtureDef = FixtureDef(rightCurveShape);
    fixturesDef.add(rightFixtureDef);

    final entranceWall = ArcShape(
      center: initialPosition + Vector2(35.7, -25.5),
      arcRadius: width / 2,
      angle: math.pi,
      rotation: 170 * math.pi / 180,
    );
    final entranceFixtureDef = FixtureDef(entranceWall);
    fixturesDef.add(entranceFixtureDef);

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
}

class _SpaceshipExitRailBottomRamp extends BodyComponent
    with InitialPosition, Layered {
  _SpaceshipExitRailBottomRamp() : super(priority: 2) {
    layer = Layer.spaceshipExitRail;
    paint = Paint()
      ..color = const Color.fromARGB(255, 185, 188, 189)
      ..style = PaintingStyle.stroke;
  }

  /// Width between walls of the ramp.
  static const width = 5.0;

  List<FixtureDef> _createFixtureDefs() {
    final fixturesDef = <FixtureDef>[];

    final leftCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(0, 10),
        Vector2(15, 10),
        Vector2(20, 0),
        Vector2(30, 0),
      ],
    )..rotate(275 * math.pi / 180);
    final leftFixtureDef = FixtureDef(leftCurveShape);
    fixturesDef.add(leftFixtureDef);

    final rightCurveShape = BezierCurveShape(
      controlPoints: [
        Vector2(0, 10 + width),
        Vector2(15, 10 + width),
        Vector2(20, 0 + width),
        Vector2(30, 0 + width),
      ],
    )..rotate(275 * math.pi / 180);
    final rightFixtureDef = FixtureDef(rightCurveShape);
    fixturesDef.add(rightFixtureDef);

    final exitWall = ArcShape(
      center: initialPosition + Vector2(36, -26),
      arcRadius: width / 2,
      angle: math.pi,
      rotation: 350 * math.pi / 180,
    );
    final exitFixtureDef = FixtureDef(exitWall);
    fixturesDef.add(exitFixtureDef);

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
}

/// {@template spaceship_exit_rail_end}
/// A sensor [BodyComponent] responsible for sending the [Ball]
/// back to the board.
/// {@endtemplate}
class SpaceshipExitRailEnd extends RampOpening {
  /// {@macro spaceship_exit_rail_end}
  SpaceshipExitRailEnd()
      : super(
          pathwayLayer: Layer.spaceshipExitRail,
          orientation: RampOrientation.down,
        ) {
    layer = Layer.spaceshipExitRail;
  }

  @override
  Shape get shape {
    return CircleShape()..radius = Spaceship.radius / 40;
  }
}

/// [ContactCallback] that handles the contact between the [Ball]
/// and a [SpaceshipExitRailEnd].
///
/// It resets the [Ball] priority and filter data so it will "be back" on the
/// board.
class SpaceshipExitRailEndBallContactCallback
    extends ContactCallback<SpaceshipExitRailEnd, Ball> {
  @override
  void begin(SpaceshipExitRailEnd exitRail, Ball ball, _) {
    ball
      ..priority = 1
      ..gameRef.reorderChildren()
      ..layer = exitRail.outsideLayer;
  }
}
