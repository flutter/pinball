import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

enum RampOrientation { up, down }

enum RampType { all, jetpack, sparky }

extension RampTypeX on RampType {
  int get maskBits => _getRampMaskBits(this);

  int _getRampMaskBits(RampType type) {
    switch (type) {
      case RampType.all:
        return Filter().maskBits;
      case RampType.jetpack:
        return 0x010;
      case RampType.sparky:
        return 0x0100;
    }
  }
}

abstract class RampArea extends BodyComponent {
  RampArea({
    required Vector2 position,
    required int maskBits,
  })  : _position = position,
        _maskBits = maskBits;

  final Vector2 _position;
  final int _maskBits;

  int get maskBits => _maskBits;
  Shape get shape;
  RampOrientation get orientation;

  @override
  Body createBody() {
    final fixtureDef = FixtureDef(shape)..isSensor = true;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = _position
      ..type = BodyType.static;

    final body = world.createBody(bodyDef);
    body.createFixture(fixtureDef).filterData
      ..categoryBits = Filter().maskBits
      ..maskBits = Filter().maskBits;

    return body;
  }
}

abstract class RampAreaCallback<Area extends RampArea>
    extends ContactCallback<Ball, Area> {
  Set get ballsInside;

  @override
  void begin(
    Ball ball,
    Area area,
    Contact _,
  ) {
    int maskBits;
    if (!ballsInside.contains(ball)) {
      maskBits = area.maskBits;
      ballsInside.add(ball);
    } else {
      maskBits = RampType.all.maskBits;
      ballsInside.remove(ball);
    }

    ball.body.fixtures.first
      ..filterData.categoryBits = maskBits
      ..filterData.maskBits = maskBits;
  }

  @override
  void end(Ball ball, Area area, Contact contact) {
    int? maskBits;

    switch (area.orientation) {
      case RampOrientation.up:
        if (ball.body.position.y > area._position.y) {
          maskBits = RampType.all.maskBits;
        }
        break;
      case RampOrientation.down:
        if (ball.body.position.y < area._position.y) {
          maskBits = RampType.all.maskBits;
        }
        break;
    }

    if (maskBits != null) {
      ball.body.fixtures.first
        ..filterData.categoryBits = maskBits
        ..filterData.maskBits = maskBits;
    }
  }
}
