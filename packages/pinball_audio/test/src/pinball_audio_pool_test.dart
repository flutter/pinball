// ignore_for_file: one_member_abstracts

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_audio/src/pinball_audio_pool.dart';

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockPlaySingleAudio extends Mock {
  Future<AudioPlayer> onCall(String path, {double volume});
}

abstract class _PreCacheSingleAudio {
  Future<void> onCall(String path);
}

class _MockPreCacheSingleAudio extends Mock implements _PreCacheSingleAudio {}

void main() {
  group('PinballAudioPool', () {
    late _PreCacheSingleAudio preCacheSingleAudio;
    late _MockPlaySingleAudio playSingleAudio;
    late PinballAudioPool pool;
    late AudioPlayer audioPlayer;

    setUp(() {
      preCacheSingleAudio = _MockPreCacheSingleAudio();
      when(() => preCacheSingleAudio.onCall(any())).thenAnswer((_) async {});

      audioPlayer = _MockAudioPlayer();
      when(() => audioPlayer.play(any(), volume: any(named: 'volume')))
          .thenAnswer((_) async => 1);

      playSingleAudio = _MockPlaySingleAudio();
      when(() => playSingleAudio.onCall(any(), volume: any(named: 'volume')))
          .thenAnswer((_) async => audioPlayer);

      pool = PinballAudioPool(
        path: 'path',
        poolSize: 1,
        preCacheSingleAudio: preCacheSingleAudio.onCall,
        playSingleAudio: playSingleAudio.onCall,
        duration: const Duration(milliseconds: 10),
      );
    });

    test('pre cache the sound', () async {
      await pool.load();
      verify(() => preCacheSingleAudio.onCall('path')).called(1);
    });

    test('plays a fresh sound', () async {
      await pool.load();
      await pool.play();

      verify(
        () => playSingleAudio.onCall(
          'path',
          volume: any(named: 'volume'),
        ),
      ).called(1);
    });

    test('plays from the pool after it returned', () async {
      await pool.load();
      await pool.play();
      await Future<void>.delayed(const Duration(milliseconds: 12));
      await pool.play();

      verify(() => audioPlayer.play('path')).called(1);
    });
  });
}
