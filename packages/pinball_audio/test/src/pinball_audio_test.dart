// ignore_for_file: prefer_const_constructors, one_member_abstracts
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_audio/gen/assets.gen.dart';
import 'package:pinball_audio/pinball_audio.dart';

class _MockAudioPool extends Mock implements AudioPool {}

class _MockAudioCache extends Mock implements AudioCache {}

class _MockCreateAudioPool extends Mock {
  Future<AudioPool> onCall(
    String sound, {
    bool? repeating,
    int? maxPlayers,
    int? minPlayers,
    String? prefix,
  });
}

class _MockConfigureAudioCache extends Mock {
  void onCall(AudioCache cache);
}

class _MockPlaySingleAudio extends Mock {
  Future<void> onCall(String url);
}

class _MockLoopSingleAudio extends Mock {
  Future<void> onCall(String url);
}

abstract class _PreCacheSingleAudio {
  Future<void> onCall(String url);
}

class _MockPreCacheSingleAudio extends Mock implements _PreCacheSingleAudio {}

class _MockRandom extends Mock implements Random {}

void main() {
  group('PinballAudio', () {
    late _MockCreateAudioPool createAudioPool;
    late _MockConfigureAudioCache configureAudioCache;
    late _MockPlaySingleAudio playSingleAudio;
    late _MockLoopSingleAudio loopSingleAudio;
    late _PreCacheSingleAudio preCacheSingleAudio;
    late Random seed;
    late PinballPlayer player;

    setUpAll(() {
      registerFallbackValue(_MockAudioCache());
    });

    setUp(() {
      createAudioPool = _MockCreateAudioPool();
      when(
        () => createAudioPool.onCall(
          any(),
          maxPlayers: any(named: 'maxPlayers'),
          prefix: any(named: 'prefix'),
        ),
      ).thenAnswer((_) async => _MockAudioPool());

      configureAudioCache = _MockConfigureAudioCache();
      when(() => configureAudioCache.onCall(any())).thenAnswer((_) {});

      playSingleAudio = _MockPlaySingleAudio();
      when(() => playSingleAudio.onCall(any())).thenAnswer((_) async {});

      loopSingleAudio = _MockLoopSingleAudio();
      when(() => loopSingleAudio.onCall(any())).thenAnswer((_) async {});

      preCacheSingleAudio = _MockPreCacheSingleAudio();
      when(() => preCacheSingleAudio.onCall(any())).thenAnswer((_) async {});

      seed = _MockRandom();

      player = PinballPlayer(
        configureAudioCache: configureAudioCache.onCall,
        createAudioPool: createAudioPool.onCall,
        playSingleAudio: playSingleAudio.onCall,
        loopSingleAudio: loopSingleAudio.onCall,
        preCacheSingleAudio: preCacheSingleAudio.onCall,
        seed: seed,
      );
    });

    test('can be instantiated', () {
      expect(PinballPlayer(), isNotNull);
    });

    group('load', () {
      test('creates the bumpers pools', () async {
        await Future.wait(player.load());

        verify(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.bumperA}',
            maxPlayers: 4,
            prefix: '',
          ),
        ).called(1);

        verify(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.bumperB}',
            maxPlayers: 4,
            prefix: '',
          ),
        ).called(1);
      });

      test('configures the audio cache instance', () async {
        await Future.wait(player.load());

        verify(() => configureAudioCache.onCall(FlameAudio.audioCache))
            .called(1);
      });

      test('sets the correct prefix', () async {
        player = PinballPlayer(
          createAudioPool: createAudioPool.onCall,
          playSingleAudio: playSingleAudio.onCall,
          preCacheSingleAudio: preCacheSingleAudio.onCall,
        );
        await Future.wait(player.load());

        expect(FlameAudio.audioCache.prefix, equals(''));
      });

      test('pre cache the assets', () async {
        await Future.wait(player.load());

        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/google.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio.onCall(
            'packages/pinball_audio/assets/sfx/io_pinball_voice_over.mp3',
          ),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/music/background.mp3'),
        ).called(1);
      });
    });

    group('bumper', () {
      late AudioPool bumperAPool;
      late AudioPool bumperBPool;

      setUp(() {
        bumperAPool = _MockAudioPool();
        when(() => bumperAPool.start(volume: any(named: 'volume')))
            .thenAnswer((_) async => () {});
        when(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.bumperA}',
            maxPlayers: any(named: 'maxPlayers'),
            prefix: any(named: 'prefix'),
          ),
        ).thenAnswer((_) async => bumperAPool);

        bumperBPool = _MockAudioPool();
        when(() => bumperBPool.start(volume: any(named: 'volume')))
            .thenAnswer((_) async => () {});
        when(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.bumperB}',
            maxPlayers: any(named: 'maxPlayers'),
            prefix: any(named: 'prefix'),
          ),
        ).thenAnswer((_) async => bumperBPool);
      });

      group('when seed is true', () {
        test('plays the bumper A sound pool', () async {
          when(seed.nextBool).thenReturn(true);
          await Future.wait(player.load());
          player.play(PinballAudio.bumper);

          verify(() => bumperAPool.start(volume: 0.6)).called(1);
        });
      });

      group('when seed is false', () {
        test('plays the bumper B sound pool', () async {
          when(seed.nextBool).thenReturn(false);
          await Future.wait(player.load());
          player.play(PinballAudio.bumper);

          verify(() => bumperBPool.start(volume: 0.6)).called(1);
        });
      });
    });

    group('googleBonus', () {
      test('plays the correct file', () async {
        await Future.wait(player.load());
        player.play(PinballAudio.google);

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.google}'),
        ).called(1);
      });
    });

    group('ioPinballVoiceOver', () {
      test('plays the correct file', () async {
        await Future.wait(player.load());
        player.play(PinballAudio.ioPinballVoiceOver);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.ioPinballVoiceOver}',
          ),
        ).called(1);
      });
    });

    group('backgroundMusic', () {
      test('plays the correct file', () async {
        await Future.wait(player.load());
        player.play(PinballAudio.backgroundMusic);

        verify(
          () => loopSingleAudio
              .onCall('packages/pinball_audio/${Assets.music.background}'),
        ).called(1);
      });
    });

    test(
      'throws assertions error when playing an unregistered audio',
      () async {
        player.audios.remove(PinballAudio.google);
        await Future.wait(player.load());

        expect(() => player.play(PinballAudio.google), throwsAssertionError);
      },
    );
  });
}
