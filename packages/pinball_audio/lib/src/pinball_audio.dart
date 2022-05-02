import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pinball_audio/gen/assets.gen.dart';

/// Function that defines the contract of the creation
/// of an [AudioPool]
typedef CreateAudioPool = Future<AudioPool> Function(
  String sound, {
  bool? repeating,
  int? maxPlayers,
  int? minPlayers,
  String? prefix,
});

/// Function that defines the contract for playing a single
/// audio
typedef PlaySingleAudio = Future<void> Function(String);

/// Function that defines the contract for looping a single
/// audio
typedef LoopSingleAudio = Future<void> Function(String);

/// Function that defines the contract for pre fetching an
/// audio
typedef PreCacheSingleAudio = Future<void> Function(String);

/// Function that defines the contract for configuring
/// an [AudioCache] instance
typedef ConfigureAudioCache = void Function(AudioCache);

/// {@template pinball_audio}
/// Sound manager for the pinball game
/// {@endtemplate}
class PinballAudio {
  /// {@macro pinball_audio}
  PinballAudio({
    CreateAudioPool? createAudioPool,
    PlaySingleAudio? playSingleAudio,
    LoopSingleAudio? loopSingleAudio,
    PreCacheSingleAudio? preCacheSingleAudio,
    ConfigureAudioCache? configureAudioCache,
  })  : _createAudioPool = createAudioPool ?? AudioPool.create,
        _playSingleAudio = playSingleAudio ?? FlameAudio.audioCache.play,
        _loopSingleAudio = loopSingleAudio ?? FlameAudio.audioCache.loop,
        _preCacheSingleAudio =
            preCacheSingleAudio ?? FlameAudio.audioCache.load,
        _configureAudioCache = configureAudioCache ??
            ((AudioCache a) {
              a.prefix = '';
            });

  final CreateAudioPool _createAudioPool;

  final PlaySingleAudio _playSingleAudio;

  final LoopSingleAudio _loopSingleAudio;

  final PreCacheSingleAudio _preCacheSingleAudio;

  final ConfigureAudioCache _configureAudioCache;

  late AudioPool _scorePool;

  /// Loads the sounds effects into the memory
  Future<void> load() async {
    _configureAudioCache(FlameAudio.audioCache);

    _scorePool = await _createAudioPool(
      _prefixFile(Assets.sfx.plim),
      maxPlayers: 4,
      prefix: '',
    );

    await Future.wait([
      _preCacheSingleAudio(_prefixFile(Assets.sfx.google)),
      _preCacheSingleAudio(_prefixFile(Assets.music.background)),
    ]);
  }

  /// Plays the basic score sound
  void score() {
    _scorePool.start();
  }

  /// Plays the google word bonus
  void googleBonus() {
    _playSingleAudio(_prefixFile(Assets.sfx.google));
  }

  /// Plays the background music
  void backgroundMusic() {
    _loopSingleAudio(_prefixFile(Assets.music.background));
  }

  String _prefixFile(String file) {
    return 'packages/pinball_audio/$file';
  }
}
