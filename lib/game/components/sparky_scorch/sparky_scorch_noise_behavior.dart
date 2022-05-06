import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Plays the sparky animation sound when in contact with a [Ball]
class SparkyScorchNoiseBehavior extends ContactBehavior {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is Ball) {
      readProvider<PinballPlayer>().play(PinballAudio.sparky);
    }
  }
}
