import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_audio/pinball_audio.dart';

part 'assets_manager_state.dart';

class AssetsManagerCubit extends Cubit<AssetsManagerState> {
  AssetsManagerCubit(this._game, this._audioPlayer)
      : super(const AssetsManagerState.initial());

  final PinballGame _game;
  final PinballAudioPlayer _audioPlayer;

  Future<void> load() async {
    /// Assigning loadables is a very expensive operation. With this purposeful
    /// delay here, which is a bit random in duration but enough to let the UI
    /// do its job without adding too much delay for the user, we are letting
    /// the UI paint first, and then we start loading the assets.
    await Future<void>.delayed(const Duration(seconds: 1));
    emit(
      state.copyWith(
        loadables: [
          _game.preFetchLeaderboard(),
          ..._game.preLoadAssets(),
          ..._audioPlayer.load(),
          ...BonusAnimation.loadAssets(),
          ...SelectedCharacter.loadAssets(),
        ],
      ),
    );
    final all = state.loadables.map((loadable) async {
      try {
        await loadable;
        emit(state.copyWith(loaded: [...state.loaded, loadable]));
      } catch (error, stackTrace) {
        emit(state.copyWith(error: '$error'));
      }
    }).toList();
    await Future.wait(all);
  }
}
