import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template layer_contact_behavior}
/// Switches the z-index of any [ZIndex] body that contacts with it.
/// {@endtemplate}
class ZIndexContactBehavior extends ContactBehavior<BodyComponent> {
  /// {@macro layer_contact_behavior}
  ZIndexContactBehavior({
    required int zIndex,
    bool onBegin = true,
  }) {
    if (onBegin) {
      onBeginContact = (other, _) => _changeZIndex(other, zIndex);
    } else {
      onEndContact = (other, _) => _changeZIndex(other, zIndex);
    }
  }

  void _changeZIndex(Object other, int zIndex) {
    if (other is! ZIndex) return;
    if (other.zIndex == zIndex) return;
    other.zIndex = zIndex;
  }
}
