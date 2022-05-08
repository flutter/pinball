// ignore_for_file: prefer_const_constructors, one_member_abstracts
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:clock/clock.dart';
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

class _MockClock extends Mock implements Clock {}

void main() {
  group('PinballAudio', () {
    late _MockCreateAudioPool createAudioPool;
    late _MockConfigureAudioCache configureAudioCache;
    late _MockPlaySingleAudio playSingleAudio;
    late _MockLoopSingleAudio loopSingleAudio;
    late _PreCacheSingleAudio preCacheSingleAudio;
    late Random seed;
    late PinballAudioPlayer audioPlayer;

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

      audioPlayer = PinballAudioPlayer(
        configureAudioCache: configureAudioCache.onCall,
        createAudioPool: createAudioPool.onCall,
        playSingleAudio: playSingleAudio.onCall,
        loopSingleAudio: loopSingleAudio.onCall,
        preCacheSingleAudio: preCacheSingleAudio.onCall,
        seed: seed,
      );
    });

    test('can be instantiated', () {
      expect(PinballAudioPlayer(), isNotNull);
    });

    group('load', () {
      test('creates the bumpers pools', () async {
        await Future.wait(audioPlayer.load());

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

      test('creates the kicker pools', () async {
        await Future.wait(audioPlayer.load());

        verify(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.kickerA}',
            maxPlayers: 4,
            prefix: '',
          ),
        ).called(1);

        verify(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.kickerB}',
            maxPlayers: 4,
            prefix: '',
          ),
        ).called(1);
      });

      test('configures the audio cache instance', () async {
        await Future.wait(audioPlayer.load());

        verify(() => configureAudioCache.onCall(FlameAudio.audioCache))
            .called(1);
      });

      test('sets the correct prefix', () async {
        audioPlayer = PinballAudioPlayer(
          createAudioPool: createAudioPool.onCall,
          playSingleAudio: playSingleAudio.onCall,
          preCacheSingleAudio: preCacheSingleAudio.onCall,
        );
        await Future.wait(audioPlayer.load());

        expect(FlameAudio.audioCache.prefix, equals(''));
      });

      test('pre cache the assets', () async {
        await Future.wait(audioPlayer.load());

        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/google.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/sparky.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/dino.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/android.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/dash.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio.onCall(
            'packages/pinball_audio/assets/sfx/io_pinball_voice_over.mp3',
          ),
        ).called(1);
        verify(
          () => preCacheSingleAudio.onCall(
            'packages/pinball_audio/assets/sfx/game_over_voice_over.mp3',
          ),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/launcher.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/cow_moo.mp3'),
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
          await Future.wait(audioPlayer.load());
          audioPlayer.play(PinballAudio.bumper);

          verify(() => bumperAPool.start(volume: 0.6)).called(1);
        });
      });

      group('when seed is false', () {
        test('plays the bumper B sound pool', () async {
          when(seed.nextBool).thenReturn(false);
          await Future.wait(audioPlayer.load());
          audioPlayer.play(PinballAudio.bumper);

          verify(() => bumperBPool.start(volume: 0.6)).called(1);
        });
      });
    });

    group('kicker', () {
      late AudioPool kickerAPool;
      late AudioPool kickerBPool;

      setUp(() {
        kickerAPool = _MockAudioPool();
        when(() => kickerAPool.start(volume: any(named: 'volume')))
            .thenAnswer((_) async => () {});
        when(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.kickerA}',
            maxPlayers: any(named: 'maxPlayers'),
            prefix: any(named: 'prefix'),
          ),
        ).thenAnswer((_) async => kickerAPool);

        kickerBPool = _MockAudioPool();
        when(() => kickerBPool.start(volume: any(named: 'volume')))
            .thenAnswer((_) async => () {});
        when(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.kickerB}',
            maxPlayers: any(named: 'maxPlayers'),
            prefix: any(named: 'prefix'),
          ),
        ).thenAnswer((_) async => kickerBPool);
      });

      group('when seed is true', () {
        test('plays the kicker A sound pool', () async {
          when(seed.nextBool).thenReturn(true);
          await Future.wait(audioPlayer.load());
          audioPlayer.play(PinballAudio.kicker);

          verify(() => kickerAPool.start(volume: 0.6)).called(1);
        });
      });

      group('when seed is false', () {
        test('plays the kicker B sound pool', () async {
          when(seed.nextBool).thenReturn(false);
          await Future.wait(audioPlayer.load());
          audioPlayer.play(PinballAudio.kicker);

          verify(() => kickerBPool.start(volume: 0.6)).called(1);
        });
      });
    });

    group('cow moo', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.cowMoo);

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.cowMoo}'),
        ).called(1);
      });

      test('only plays the sound again after 2 seconds', () async {
        final clock = _MockClock();
        await withClock(clock, () async {
          when(clock.now).thenReturn(DateTime(2022));
          await Future.wait(audioPlayer.load());
          audioPlayer
            ..play(PinballAudio.cowMoo)
            ..play(PinballAudio.cowMoo);

          verify(
            () => playSingleAudio
                .onCall('packages/pinball_audio/${Assets.sfx.cowMoo}'),
          ).called(1);

          when(clock.now).thenReturn(DateTime(2022, 1, 1, 1, 2));
          audioPlayer.play(PinballAudio.cowMoo);

          verify(
            () => playSingleAudio
                .onCall('packages/pinball_audio/${Assets.sfx.cowMoo}'),
          ).called(1);
        });
      });
    });

    group('google', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.google);

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.google}'),
        ).called(1);
      });
    });

    group('sparky', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.sparky);

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.sparky}'),
        ).called(1);
      });
    });

    group('dino', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.dino);

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.dino}'),
        ).called(1);
      });
    });

    group('android', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.android);

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.android}'),
        ).called(1);
      });
    });

    group('dash', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.dash);

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.dash}'),
        ).called(1);
      });
    });

    group('launcher', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.launcher);

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.launcher}'),
        ).called(1);
      });
    });

    group('ioPinballVoiceOver', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.ioPinballVoiceOver);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.ioPinballVoiceOver}',
          ),
        ).called(1);
      });
    });

    group('gameOverVoiceOver', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.gameOverVoiceOver);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.gameOverVoiceOver}',
          ),
        ).called(1);
      });
    });

    group('backgroundMusic', () {
      test('plays the correct file', () async {
        await Future.wait(audioPlayer.load());
        audioPlayer.play(PinballAudio.backgroundMusic);

        verify(
          () => loopSingleAudio
              .onCall('packages/pinball_audio/${Assets.music.background}'),
        ).called(1);
      });
    });

    test(
      'throws assertions error when playing an unregistered audio',
      () async {
        audioPlayer.audios.remove(PinballAudio.google);
        await Future.wait(audioPlayer.load());

        expect(
          () => audioPlayer.play(PinballAudio.google),
          throwsAssertionError,
        );
      },
    );
  });
}
