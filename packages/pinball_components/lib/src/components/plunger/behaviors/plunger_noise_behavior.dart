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
  late final PinballAudioPlayer _audioPlayer;

  @override
  void onNewState(PlungerState state) {
    super.onNewState(state);
    if (state.isReleasing) {
      _audioPlayer.play(PinballAudio.launcher);
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _audioPlayer = readProvider<PinballAudioPlayer>();
  }
}
