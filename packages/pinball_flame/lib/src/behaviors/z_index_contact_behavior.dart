import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template layer_contact_behavior}
/// Switches the z-index of any [ZIndex] body that contacts with it.
/// {@endtemplate}
class ZIndexContactBehavior extends ContactBehavior<BodyComponent> {
  /// {@macro layer_contact_behavior}
  ZIndexContactBehavior({required int zIndex}) : _zIndex = zIndex;

  final int _zIndex;

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! ZIndex) return;
    if (other.zIndex == _zIndex) return;
    other.zIndex = _zIndex;
  }
}
