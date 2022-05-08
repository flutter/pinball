import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class GoogleRolloverBallContactBehavior
    extends ContactBehavior<GoogleRollover> {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;
    readBloc<GoogleWordCubit, GoogleWordState>().onRolloverContacted();
    parent.firstChild<SpriteAnimationComponent>()?.playing = true;
  }
}
