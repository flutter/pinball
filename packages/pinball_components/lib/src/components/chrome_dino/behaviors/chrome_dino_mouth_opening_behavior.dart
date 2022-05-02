import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template chrome_dino_mouth_opening_behavior}
/// Allows a [Ball] to enter the [ChromeDino] mouth when it is open.
/// {@endtemplate}
class ChromeDinoMouthOpeningBehavior extends ContactBehavior<ChromeDino> {
  @override
  void preSolve(Object other, Contact contact, Manifold oldManifold) {
    super.preSolve(other, contact, oldManifold);
    if (other is! Ball) return;

    if (parent.bloc.state.isMouthOpen && parent.firstChild<Ball>() == null) {
      contact.setEnabled(false);
    }
  }
}
