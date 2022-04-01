import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pinball_audio/gen/assets.gen.dart';

/// {@template pinball_audio}
/// Sound manager for the pinball game
/// {@endtemplate}
class PinballAudio {
  /// {@macro pinball_audio}
  PinballAudio();

  late AudioPool _scorePool;

  /// Loads the sounds effects into the memory
  Future<void> load() async {
    FlameAudio.audioCache.prefix = '';
    _scorePool = await AudioPool.create(
      _prefixFile(Assets.sfx.plim),
      maxPlayers: 4,
      prefix: '',
    );
  }

  /// Plays the basic score sound
  void score() {
    _scorePool.start();
  }

  /// Plays the google word bonus
  void googleBonus() {
    FlameAudio.audioCache.play(_prefixFile(Assets.sfx.google));
  }

  String _prefixFile(String file) {
    return 'packages/pinball_audio/$file';
  }
}
