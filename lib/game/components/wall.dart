// ignore_for_file: avoid_renaming_method_parameters

import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart' hide Assets;

/// {@template wall}
/// A continuous generic and [BodyType.static] barrier that divides a game area.
/// {@endtemplate}
// TODO(alestiago): Remove [Wall] for [Pathway.straight].
class Wall extends BodyComponent {
  /// {@macro wall}
  Wall({
    required this.start,
    required this.end,
  });

  /// The [start] of the [Wall].
  final Vector2 start;

  /// The [end] of the [Wall].
  final Vector2 end;

  @override
  Body createBody() {
    final shape = EdgeShape()..set(start, end);

    final fixtureDef = FixtureDef(shape)
      ..restitution = 0.1
      ..friction = 0;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = Vector2.zero()
      ..type = BodyType.static;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

/// {@template bottom_wall}
/// [Wall] located at the bottom of the board.
///
/// {@endtemplate}
class BottomWall extends Wall with ContactCallbacks {
  /// {@macro bottom_wall}
  BottomWall()
      : super(
          start: BoardDimensions.bounds.bottomLeft.toVector2(),
          end: BoardDimensions.bounds.bottomRight.toVector2(),
        );

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! ControlledBall) return;
    other.controller.lost();
  }
}
