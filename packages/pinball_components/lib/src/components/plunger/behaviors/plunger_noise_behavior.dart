import 'package:flame/components.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Plays the [PinballAudio.launcher] sound.
///
/// It is attached when the plunger is released.
class PlungerNoiseBehavior extends Component {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    readProvider<PinballAudioPlayer>().play(PinballAudio.launcher);
  }

  @override
  void update(double dt) {
    super.update(dt);
    removeFromParent();
  }
}
