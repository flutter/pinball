import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// {@template chrome_dino_chomping_behavior}
/// Chomps a [Ball] after it has entered the [ChromeDino]'s mouth.
///
/// The chomped [Ball] is hidden in the mouth until it is spit out.
/// {@endtemplate}
class ChromeDinoChompingBehavior extends ContactBehavior<ChromeDino> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    other.firstChild<SpriteComponent>()!.setOpacity(0);
    parent.bloc.onChomp(other);
  }
}
