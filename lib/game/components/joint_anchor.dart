import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';

/// {@template joint_anchor}
/// Non visual [BodyComponent] used to hold a [BodyType.dynamic] in [Joint]s
/// with this [BodyType.static].
///
/// It is recommended to use [JointAnchor.body.position] to position the anchor
/// point when initializing a [JointDef].
///
/// ```dart
/// initialize(
///   dynamicBody.body,
///   anchor.body,
///   anchor.body.position,
/// );
/// ```
/// {@endtemplate}
class JointAnchor extends BodyComponent with InitialPosition {
  /// {@macro joint_anchor}
  JointAnchor();

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = initialPosition;
    return world.createBody(bodyDef);
  }
}
