import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:pinball_audio/pinball_audio.dart';

class _PlayerEntry {
  _PlayerEntry({
    required this.available,
    required this.player,
  });

  bool available;
  final AudioPlayer player;
}

/// {@template pinball_audio_pool}
/// Creates an audio player pool used to trigger many sounds at the same time.
/// {@endtemplate}
class PinballAudioPool {
  /// {@macro pinball_audio_pool}
  PinballAudioPool({
    required this.path,
    required this.poolSize,
    required this.preCacheSingleAudio,
    required this.playSingleAudio,
    required this.duration,
  });

  /// Sounds path.
  final String path;

  /// Max size of this pool.
  final int poolSize;

  /// Function to cache audios.
  final PreCacheSingleAudio preCacheSingleAudio;

  /// Function to play audios.
  final PlaySingleAudio playSingleAudio;

  /// How long the sound lasts.
  final Duration duration;

  final List<_PlayerEntry> _players = [];

  /// Loads the pool.
  Future<void> load() async {
    await preCacheSingleAudio(path);
  }

  /// Plays the pool.
  Future<void> play({double volume = 1}) async {
    AudioPlayer? player;
    if (_players.length < poolSize) {
      _players.add(
        _PlayerEntry(
          available: false,
          player: player = await playSingleAudio(path, volume: volume),
        ),
      );
    } else {
      final entries = _players.where((entry) => entry.available);
      if (entries.isNotEmpty) {
        final entry = entries.first..available = false;

        player = entry.player;
        unawaited(entry.player.play(path, volume: volume));
      }
    }

    if (player != null) {
      unawaited(
        Future<void>.delayed(duration).then(
          (_) {
            _returnEntryAvailability(player!);
          },
        ),
      );
    } else {}
  }

  void _returnEntryAvailability(
    AudioPlayer player,
  ) {
    _players.where((entry) => entry.player == player).single.available = true;
  }
}
