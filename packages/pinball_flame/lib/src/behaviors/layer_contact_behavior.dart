import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template layer_contact_behavior}
/// Switches the [Layer] of any [Layered] body that contacts with it.
/// {@endtemplate}
class LayerContactBehavior extends ContactBehavior<BodyComponent> {
  /// {@macro layer_contact_behavior}
  LayerContactBehavior({
    required Layer layer,
    bool onBegin = true,
  }) {
    if (onBegin) {
      onBeginContact = (other, _) => _changeLayer(other, layer);
    } else {
      onEndContact = (other, _) => _changeLayer(other, layer);
    }
  }

  void _changeLayer(Object other, Layer layer) {
    if (other is! Layered) return;
    if (other.layer == layer) return;
    other.layer = layer;
  }
}
