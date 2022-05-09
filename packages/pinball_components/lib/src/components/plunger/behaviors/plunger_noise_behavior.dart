import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Plays the [PinballAudio.launcher] sound.
///
/// It is attached when the plunger is released.
class PlungerNoiseBehavior extends Component
    with FlameBlocListenable<PlungerCubit, PlungerState> {
  @override
  void onNewState(PlungerState state) {
    super.onNewState(state);
    if (state.isReleasing) {
      readProvider<PinballAudioPlayer>().play(PinballAudio.launcher);
    }
  }
}
