import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

class FlipperNoiseBehavior extends Component
    with
        FlameBlocListenable<FlipperCubit, FlipperState>,
        FlameBlocReader<FlipperCubit, FlipperState> {
  @override
  void onNewState(FlipperState state) {
    super.onNewState(state);
    if (bloc.state.isMovingUp) {
      readProvider<PinballAudioPlayer>().play(PinballAudio.flipper);
    }
  }
}
