import 'package:flame_forge2d/flame_forge2d.dart';

/// {@template anchor}
/// Non visual [BodyComponent] used to hold a [BodyType.dynamic] in [Joint]s
/// with this [BodyType.static].
///
/// It is recommended to [_position] the anchor first and then use the body
/// position as the anchor point when initializing a [JointDef].
///
/// ```dart
/// initialize(
///   dynamicBody.body,
///   anchor.body,
///   anchor.body.position,
/// );
/// ```
/// {@endtemplate}
class Anchor extends BodyComponent {
  /// {@macro anchor}
  Anchor({
    required Vector2 position,
  }) : _position = position;

  final Vector2 _position;

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = _position;

    return world.createBody(bodyDef);
  }
}
