// ignore_for_file: prefer_const_constructors, one_member_abstracts
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:clock/clock.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_audio/gen/assets.gen.dart';
import 'package:pinball_audio/pinball_audio.dart';

class _MockAudioCache extends Mock implements AudioCache {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockConfigureAudioCache extends Mock {
  void onCall(AudioCache cache);
}

class _MockPlaySingleAudio extends Mock {
  Future<AudioPlayer> onCall(String path, {double volume});
}

class _MockLoopSingleAudio extends Mock {
  Future<void> onCall(String path, {double volume});
}

abstract class _PreCacheSingleAudio {
  Future<void> onCall(String path);
}

class _MockPreCacheSingleAudio extends Mock implements _PreCacheSingleAudio {}

class _MockRandom extends Mock implements Random {}

class _MockClock extends Mock implements Clock {}

void main() {
  group('PinballAudio', () {
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
      configureAudioCache = _MockConfigureAudioCache();
      when(() => configureAudioCache.onCall(any())).thenAnswer((_) {});

      playSingleAudio = _MockPlaySingleAudio();
      when(() => playSingleAudio.onCall(any(), volume: any(named: 'volume')))
          .thenAnswer((_) async => _MockAudioPlayer());

      loopSingleAudio = _MockLoopSingleAudio();
      when(() => loopSingleAudio.onCall(any(), volume: any(named: 'volume')))
          .thenAnswer((_) async {});

      preCacheSingleAudio = _MockPreCacheSingleAudio();
      when(() => preCacheSingleAudio.onCall(any())).thenAnswer((_) async {});

      seed = _MockRandom();

      audioPlayer = PinballAudioPlayer(
        configureAudioCache: configureAudioCache.onCall,
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
      test('configures the audio cache instance', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );

        verify(() => configureAudioCache.onCall(FlameAudio.audioCache))
            .called(1);
      });

      test('sets the correct prefix', () async {
        audioPlayer = PinballAudioPlayer(
          playSingleAudio: playSingleAudio.onCall,
          preCacheSingleAudio: preCacheSingleAudio.onCall,
        );
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );

        expect(FlameAudio.audioCache.prefix, equals(''));
      });

      test('pre cache the assets', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );

        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/bumper_a.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/bumper_b.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/kicker_a.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/kicker_b.mp3'),
        ).called(1);
        verify(
          () => preCacheSingleAudio
              .onCall('packages/pinball_audio/assets/sfx/flipper.mp3'),
        ).called(1);
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
              .onCall('packages/pinball_audio/assets/sfx/rollover.mp3'),
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
      group('when seed is true', () {
        test('plays the bumper A sound pool', () async {
          when(seed.nextBool).thenReturn(true);
          await Future.wait(
            audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
          );
          audioPlayer.play(PinballAudio.bumper);

          verify(
            () => playSingleAudio.onCall(
              'packages/pinball_audio/${Assets.sfx.bumperA}',
              volume: 0.6,
            ),
          ).called(1);
        });
      });

      group('when seed is false', () {
        test('plays the bumper B sound pool', () async {
          when(seed.nextBool).thenReturn(false);
          await Future.wait(
            audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
          );
          audioPlayer.play(PinballAudio.bumper);

          verify(
            () => playSingleAudio.onCall(
              'packages/pinball_audio/${Assets.sfx.bumperB}',
              volume: 0.6,
            ),
          ).called(1);
        });
      });
    });

    group('kicker', () {
      group('when seed is true', () {
        test('plays the kicker A sound pool', () async {
          when(seed.nextBool).thenReturn(true);
          await Future.wait(
            audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
          );
          audioPlayer.play(PinballAudio.kicker);

          verify(
            () => playSingleAudio.onCall(
              'packages/pinball_audio/${Assets.sfx.kickerA}',
              volume: 0.6,
            ),
          ).called(1);
        });
      });

      group('when seed is false', () {
        test('plays the kicker B sound pool', () async {
          when(seed.nextBool).thenReturn(false);
          await Future.wait(
            audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
          );
          audioPlayer.play(PinballAudio.kicker);

          verify(
            () => playSingleAudio.onCall(
              'packages/pinball_audio/${Assets.sfx.kickerB}',
              volume: 0.6,
            ),
          ).called(1);
        });
      });
    });

    group('flipper', () {
      test('plays the flipper sound pool', () async {
        when(seed.nextBool).thenReturn(true);
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.flipper);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.flipper}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });
    });

    group('cow moo', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.cowMoo);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.cowMoo}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });

      test('only plays the sound again after 2 seconds', () async {
        final clock = _MockClock();
        await withClock(clock, () async {
          final audioPlayerInstance = _MockAudioPlayer();
          when(
            () => playSingleAudio.onCall(any(), volume: any(named: 'volume')),
          ).thenAnswer((_) async => audioPlayerInstance);

          when(clock.now).thenReturn(DateTime(2022));
          await Future.wait(
            audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
          );
          audioPlayer
            ..play(PinballAudio.cowMoo)
            ..play(PinballAudio.cowMoo);

          verify(
            () => playSingleAudio.onCall(
              'packages/pinball_audio/${Assets.sfx.cowMoo}',
              volume: any(named: 'volume'),
            ),
          ).called(1);

          when(clock.now).thenReturn(DateTime(2022, 1, 1, 1, 2));
          audioPlayer.play(PinballAudio.cowMoo);

          verify(
            () => playSingleAudio.onCall(
              'packages/pinball_audio/${Assets.sfx.cowMoo}',
              volume: any(named: 'volume'),
            ),
          ).called(1);
        });
      });
    });

    group('google', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.google);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.google}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });

      test('uses the cached player on the second time', () async {
        final audioPlayerCache = _MockAudioPlayer();
        when(() => audioPlayerCache.play(any(), volume: any(named: 'volume')))
            .thenAnswer((_) async => 0);

        when(() => playSingleAudio.onCall(any(), volume: any(named: 'volume')))
            .thenAnswer((_) async => audioPlayerCache);
        audioPlayer = PinballAudioPlayer(
          configureAudioCache: configureAudioCache.onCall,
          playSingleAudio: playSingleAudio.onCall,
          loopSingleAudio: loopSingleAudio.onCall,
          preCacheSingleAudio: preCacheSingleAudio.onCall,
          seed: seed,
        );

        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.google);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.google}',
            volume: any(named: 'volume'),
          ),
        ).called(1);

        await Future.microtask(() {});

        audioPlayer.play(PinballAudio.google);
        verify(
          () => audioPlayerCache.play(
            'packages/pinball_audio/${Assets.sfx.google}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });
    });

    group('sparky', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.sparky);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.sparky}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });
    });

    group('dino', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.dino);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.dino}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });

      test('only plays the sound again after 6 seconds', () async {
        final clock = _MockClock();
        await withClock(clock, () async {
          when(clock.now).thenReturn(DateTime(2022));
          await Future.wait(
            audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
          );
          audioPlayer
            ..play(PinballAudio.dino)
            ..play(PinballAudio.dino);

          verify(
            () => playSingleAudio.onCall(
              'packages/pinball_audio/${Assets.sfx.dino}',
              volume: any(named: 'volume'),
            ),
          ).called(1);

          when(clock.now).thenReturn(DateTime(2022, 1, 1, 1, 6));
          audioPlayer.play(PinballAudio.dino);

          verify(
            () => playSingleAudio.onCall(
              'packages/pinball_audio/${Assets.sfx.dino}',
              volume: any(named: 'volume'),
            ),
          ).called(1);
        });
      });
    });

    group('android', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.android);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.android}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });
    });

    group('dash', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.dash);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.dash}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });
    });

    group('launcher', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.launcher);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.launcher}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });
    });

    group('rollover', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.rollover);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.rollover}',
            volume: .3,
          ),
        ).called(1);
      });
    });

    group('ioPinballVoiceOver', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.ioPinballVoiceOver);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.ioPinballVoiceOver}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });
    });

    group('gameOverVoiceOver', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.gameOverVoiceOver);

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.gameOverVoiceOver}',
            volume: any(named: 'volume'),
          ),
        ).called(1);
      });
    });

    group('backgroundMusic', () {
      test('plays the correct file', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer.play(PinballAudio.backgroundMusic);

        verify(
          () => loopSingleAudio.onCall(
            'packages/pinball_audio/${Assets.music.background}',
            volume: .6,
          ),
        ).called(1);
      });

      test('plays only once', () async {
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );
        audioPlayer
          ..play(PinballAudio.backgroundMusic)
          ..play(PinballAudio.backgroundMusic);

        verify(
          () => loopSingleAudio.onCall(
            'packages/pinball_audio/${Assets.music.background}',
            volume: .6,
          ),
        ).called(1);
      });
    });

    test(
      'throws assertions error when playing an unregistered audio',
      () async {
        audioPlayer.audios.remove(PinballAudio.google);
        await Future.wait(
          audioPlayer.load().map((loadableBuilder) => loadableBuilder()),
        );

        expect(
          () => audioPlayer.play(PinballAudio.google),
          throwsAssertionError,
        );
      },
    );
  });
}
