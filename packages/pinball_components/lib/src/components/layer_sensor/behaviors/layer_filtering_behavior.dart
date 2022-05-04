// ignore_for_file: public_member_api_docs

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class LayerFilteringBehavior extends ContactBehavior<LayerSensor> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    if (other.layer != parent.insideLayer) {
      final isBallEnteringOpening =
          (parent.orientation == LayerEntranceOrientation.down &&
                  other.body.linearVelocity.y < 0) ||
              (parent.orientation == LayerEntranceOrientation.up &&
                  other.body.linearVelocity.y > 0);

      if (isBallEnteringOpening) {
        other
          ..layer = parent.insideLayer
          ..zIndex = parent.insideZIndex;
      }
    } else {
      other
        ..layer = parent.outsideLayer
        ..zIndex = parent.outsideZIndex;
    }
  }
}
