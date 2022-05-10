import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:clock/clock.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:pinball_audio/gen/assets.gen.dart';
import 'package:pinball_audio/src/pinball_audio_pool.dart';

/// Sounds available to play.
enum PinballAudio {
  /// Google.
  google,

  /// Bumper.
  bumper,

  /// Cow moo.
  cowMoo,

  /// Background music.
  backgroundMusic,

  /// IO Pinball voice over.
  ioPinballVoiceOver,

  /// Game over.
  gameOverVoiceOver,

  /// Launcher.
  launcher,

  /// Kicker.
  kicker,

  /// Rollover.
  rollover,

  /// Sparky.
  sparky,

  /// Android.
  android,

  /// Dino.
  dino,

  /// Dash.
  dash,

  /// Flipper.
  flipper,
}

/// Defines the contract for playing a single audio.
typedef PlaySingleAudio = Future<AudioPlayer> Function(String, {double volume});

/// Defines the contract for looping a single audio.
typedef LoopSingleAudio = Future<void> Function(String, {double volume});

/// Defines the contract for pre fetching an audio.
typedef PreCacheSingleAudio = Future<void> Function(String);

/// Defines the contract for configuring an [AudioCache] instance.
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
    this.volume,
  });

  final PreCacheSingleAudio preCacheSingleAudio;
  final PlaySingleAudio playSingleAudio;
  final String path;
  final double? volume;
  AudioPlayer? _player;

  @override
  Future<void> load() => preCacheSingleAudio(prefixFile(path));

  @override
  Future<void> play() async {
    final url = prefixFile(path);
    final volume = this.volume ?? 1;
    if (_player == null) {
      _player = await playSingleAudio(url, volume: volume);
    } else {
      await _player!.play(url, volume: volume);
    }
  }
}

class _LoopAudio extends _Audio {
  _LoopAudio({
    required this.preCacheSingleAudio,
    required this.loopSingleAudio,
    required this.path,
    this.volume,
  });

  final PreCacheSingleAudio preCacheSingleAudio;
  final LoopSingleAudio loopSingleAudio;
  final String path;
  final double? volume;

  @override
  Future<void> load() => preCacheSingleAudio(prefixFile(path));

  @override
  void play() {
    loopSingleAudio(prefixFile(path), volume: volume ?? 1);
  }
}

class _SingleLoopAudio extends _LoopAudio {
  _SingleLoopAudio({
    required PreCacheSingleAudio preCacheSingleAudio,
    required LoopSingleAudio loopSingleAudio,
    required String path,
    double? volume,
  }) : super(
          preCacheSingleAudio: preCacheSingleAudio,
          loopSingleAudio: loopSingleAudio,
          path: path,
          volume: volume,
        );

  bool _playing = false;

  @override
  void play() {
    if (!_playing) {
      super.play();
      _playing = true;
    }
  }
}

class _SingleAudioPool extends _Audio {
  _SingleAudioPool({
    required this.path,
    required this.duration,
    required this.maxPlayers,
    required this.preCacheSingleAudio,
    required this.playSingleAudio,
  });

  final String path;
  final int maxPlayers;
  final Duration duration;
  final PreCacheSingleAudio preCacheSingleAudio;
  final PlaySingleAudio playSingleAudio;
  late PinballAudioPool pool;

  @override
  Future<void> load() async {
    pool = PinballAudioPool(
      path: prefixFile(path),
      poolSize: maxPlayers,
      preCacheSingleAudio: preCacheSingleAudio,
      playSingleAudio: playSingleAudio,
      duration: duration,
    );
    await pool.load();
  }

  @override
  void play() => pool.play();
}

class _RandomABAudio extends _Audio {
  _RandomABAudio({
    required this.preCacheSingleAudio,
    required this.playSingleAudio,
    required this.seed,
    required this.audioAssetA,
    required this.audioAssetB,
    required this.duration,
    this.volume,
  });

  final PreCacheSingleAudio preCacheSingleAudio;
  final PlaySingleAudio playSingleAudio;
  final Random seed;
  final String audioAssetA;
  final String audioAssetB;
  final Duration duration;
  final double? volume;

  late PinballAudioPool audioA;
  late PinballAudioPool audioB;

  @override
  Future<void> load() async {
    audioA = PinballAudioPool(
      path: prefixFile(audioAssetA),
      poolSize: 4,
      preCacheSingleAudio: preCacheSingleAudio,
      playSingleAudio: playSingleAudio,
      duration: duration,
    );
    audioB = PinballAudioPool(
      path: prefixFile(audioAssetB),
      poolSize: 4,
      preCacheSingleAudio: preCacheSingleAudio,
      playSingleAudio: playSingleAudio,
      duration: duration,
    );
    await Future.wait([audioA.load(), audioB.load()]);
  }

  @override
  void play() {
    (seed.nextBool() ? audioA : audioB).play(volume: volume ?? 1);
  }
}

class _ThrottledAudio extends _SimplePlayAudio {
  _ThrottledAudio({
    required PreCacheSingleAudio preCacheSingleAudio,
    required PlaySingleAudio playSingleAudio,
    required String path,
    required this.duration,
  }) : super(
          preCacheSingleAudio: preCacheSingleAudio,
          playSingleAudio: playSingleAudio,
          path: path,
        );

  final Duration duration;

  DateTime? _lastPlayed;

  @override
  Future<void> load() => preCacheSingleAudio(prefixFile(path));

  @override
  Future<void> play() async {
    final now = clock.now();
    if (_lastPlayed == null ||
        (_lastPlayed != null && now.difference(_lastPlayed!) > duration)) {
      _lastPlayed = now;
      await super.play();
    }
  }
}

/// {@template pinball_audio_player}
/// Sound manager for the pinball game.
/// {@endtemplate}
class PinballAudioPlayer {
  /// {@macro pinball_audio_player}
  PinballAudioPlayer({
    PlaySingleAudio? playSingleAudio,
    LoopSingleAudio? loopSingleAudio,
    PreCacheSingleAudio? preCacheSingleAudio,
    ConfigureAudioCache? configureAudioCache,
    Random? seed,
  })  : _playSingleAudio = playSingleAudio ?? FlameAudio.audioCache.play,
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
      PinballAudio.sparky: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.sparky,
      ),
      PinballAudio.dino: _ThrottledAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.dino,
        duration: const Duration(seconds: 6),
      ),
      PinballAudio.dash: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.dash,
      ),
      PinballAudio.android: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.android,
      ),
      PinballAudio.launcher: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.launcher,
      ),
      PinballAudio.rollover: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.rollover,
        volume: 0.3,
      ),
      PinballAudio.flipper: _SingleAudioPool(
        path: Assets.sfx.flipper,
        maxPlayers: 4,
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        duration: const Duration(milliseconds: 200),
      ),
      PinballAudio.ioPinballVoiceOver: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.ioPinballVoiceOver,
      ),
      PinballAudio.gameOverVoiceOver: _SimplePlayAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.gameOverVoiceOver,
      ),
      PinballAudio.bumper: _RandomABAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        seed: _seed,
        audioAssetA: Assets.sfx.bumperA,
        audioAssetB: Assets.sfx.bumperB,
        duration: const Duration(seconds: 1),
        volume: 0.6,
      ),
      PinballAudio.kicker: _RandomABAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        seed: _seed,
        audioAssetA: Assets.sfx.kickerA,
        audioAssetB: Assets.sfx.kickerB,
        duration: const Duration(seconds: 1),
        volume: 0.6,
      ),
      PinballAudio.cowMoo: _ThrottledAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        playSingleAudio: _playSingleAudio,
        path: Assets.sfx.cowMoo,
        duration: const Duration(seconds: 2),
      ),
      PinballAudio.backgroundMusic: _SingleLoopAudio(
        preCacheSingleAudio: _preCacheSingleAudio,
        loopSingleAudio: _loopSingleAudio,
        path: Assets.music.background,
        volume: .6,
      ),
    };
  }

  final PlaySingleAudio _playSingleAudio;

  final LoopSingleAudio _loopSingleAudio;

  final PreCacheSingleAudio _preCacheSingleAudio;

  final ConfigureAudioCache _configureAudioCache;

  final Random _seed;

  /// Registered audios on the Player.
  @visibleForTesting
  // ignore: library_private_types_in_public_api
  late final Map<PinballAudio, _Audio> audios;

  /// Loads the sounds effects into the memory.
  List<Future<void> Function()> load() {
    _configureAudioCache(FlameAudio.audioCache);

    return audios.values.map((a) => a.load).toList();
  }

  /// Plays the received audio.
  void play(PinballAudio audio) {
    assert(
      audios.containsKey(audio),
      'Tried to play unregistered audio $audio',
    );
    audios[audio]?.play();
  }
}
