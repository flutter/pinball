import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pinball_audio/gen/assets.gen.dart';

/// Sounds available for play
enum PinballAudio {
  /// Google
  google,

  /// Bumper
  bumper,

  /// Background music
  backgroundMusic,

  /// IO Pinball voice over
  ioPinballVoiceOver
}

/// Defines the contract of the creation of an [AudioPool].
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

abstract class _Audio {
  void play();
  Future<void> load();

  String prefixFile(String file) {
    return 'packages/pinball_audio/$file';
  }
}

class _SimplePlayAudio extends _Audio {
  _SimplePlayAudio({
    required this.preCacheSingleAudio,
    required this.playSingleAudio,
    required this.path,
  });

  final PreCacheSingleAudio preCacheSingleAudio;
  final PlaySingleAudio playSingleAudio;
  final String path;

  @override
  Future<void> load() => preCacheSingleAudio(prefixFile(path));

  @override
  void play() {
    playSingleAudio(prefixFile(path));
  }
}

class _LoopAudio extends _Audio {
  _LoopAudio({
    required this.preCacheSingleAudio,
    required this.loopSingleAudio,
    required this.path,
  });

  final PreCacheSingleAudio preCacheSingleAudio;
  final LoopSingleAudio loopSingleAudio;
  final String path;

  @override
  Future<void> load() => preCacheSingleAudio(prefixFile(path));

  @override
  void play() {
    loopSingleAudio(prefixFile(path));
  }
}

class _BumperAudio extends _Audio {
  _BumperAudio({
    required this.createAudioPool,
    required this.seed,
  });

  final CreateAudioPool createAudioPool;
  final Random seed;

  late AudioPool bumperA;
  late AudioPool bumperB;

  @override
  Future<void> load() async {
    await Future.wait(
      [
        createAudioPool(
          prefixFile(Assets.sfx.bumperA),
          maxPlayers: 4,
          prefix: '',
        ).then((pool) => bumperA = pool),
        createAudioPool(
          prefixFile(Assets.sfx.bumperB),
          maxPlayers: 4,
          prefix: '',
        ).then((pool) => bumperB = pool),
      ],
    );
  }

  @override
  void play() {
    (seed.nextBool() ? bumperA : bumperB).start(volume: 0.6);
  }
}

/// {@template pinball_player}
/// Sound manager for the pinball game
/// {@endtemplate}
class PinballPlayer {
  /// {@macro pinball_player}
  PinballPlayer({
    CreateAudioPool? createAudioPool,
    PlaySingleAudio? playSingleAudio,
    LoopSingleAudio? loopSingleAudio,
    PreCacheSingleAudio? preCacheSingleAudio,
    ConfigureAudioCache? configureAudioCache,
    Random? seed,
  })  : _createAudioPool = createAudioPool ?? AudioPool.create,
        _playSingleAudio = playSingleAudio ?? FlameAudio.audioCache.play,
        _loopSingleAudio = loopSingleAudio ?? FlameAudio.audioCache.loop,
        _preCacheSingleAudio =
            preCacheSingleAudio ?? FlameAudio.audioCache.load,
        _configureAudioCache = configureAudioCache ??
            ((AudioCache a) {
              a.prefix = '';
            }),
        _seed = seed ?? Random() {
    audios = {
      PinballAudio.google: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.google,
      ),
      PinballAudio.ioPinballVoiceOver: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.ioPinballVoiceOver,
      ),
      PinballAudio.bumper: _BumperAudio(
        createAudioPool: _createAudioPool,
        seed: _seed,
      ),
      PinballAudio.backgroundMusic: _LoopAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        loopSingleAudio: _loopSingleAudio,
        path: Assets.music.background,
      ),
    };
  }

  final CreateAudioPool _createAudioPool;

  final PlaySingleAudio _playSingleAudio;

  final LoopSingleAudio _loopSingleAudio;

  final PreCacheSingleAudio _preCacheSingleAudio;

  final ConfigureAudioCache _configureAudioCache;

  final Random _seed;

  /// Registered audios on the Player
  @visibleForTesting
  // ignore: library_private_types_in_public_api
  late final Map<PinballAudio, _Audio> audios;

  /// Loads the sounds effects into the memory
  List<Future<void>> load() {
    _configureAudioCache(FlameAudio.audioCache);

    return audios.values.map((a) => a.load()).toList();
  }

  /// Plays the received auido
  void play(PinballAudio audio) {
    assert(
      audios.containsKey(audio),
      'Tried to play unregistered audio $audio',
    );
    audios[audio]?.play();
  }
}
