import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Behavior that handles playing a bonus sound effect
class BonusNoiseBehavior extends Component {
  @override
  Future<void> onLoad() async {
    await add(
      FlameBlocListener<GameBloc, GameState>(
        listenWhen: (previous, current) {
          return previous.bonusHistory.length != current.bonusHistory.length;
        },
        onNewState: (state) {
          final bonus = state.bonusHistory.last;
          final audioPlayer = readProvider<PinballPlayer>();

          switch (bonus) {
            case GameBonus.googleWord:
              audioPlayer.play(PinballAudio.google);
              break;
            case GameBonus.sparkyTurboCharge:
              audioPlayer.play(PinballAudio.sparky);
              break;
            case GameBonus.dinoChomp:
              audioPlayer.play(PinballAudio.dino);
              break;
            case GameBonus.androidSpaceship:
              audioPlayer.play(PinballAudio.android);
              break;
            case GameBonus.dashNest:
              audioPlayer.play(PinballAudio.dash);
              break;
          }
        },
      ),
    );
  }
}
