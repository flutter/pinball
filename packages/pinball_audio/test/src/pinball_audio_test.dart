// ignore_for_file: prefer_const_constructors, one_member_abstracts
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

void main() {
  group('PinballAudio', () {
    late _MockCreateAudioPool createAudioPool;
    late _MockConfigureAudioCache configureAudioCache;
    late _MockPlaySingleAudio playSingleAudio;
    late _MockLoopSingleAudio loopSingleAudio;
    late _PreCacheSingleAudio preCacheSingleAudio;
    late PinballAudio audio;

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

      audio = PinballAudio(
        configureAudioCache: configureAudioCache.onCall,
        createAudioPool: createAudioPool.onCall,
        playSingleAudio: playSingleAudio.onCall,
        loopSingleAudio: loopSingleAudio.onCall,
        preCacheSingleAudio: preCacheSingleAudio.onCall,
      );
    });

    test('can be instantiated', () {
      expect(PinballAudio(), isNotNull);
    });

    group('load', () {
      test('creates the score pool', () async {
        await audio.load();

        verify(
          () => createAudioPool.onCall(
            'packages/pinball_audio/${Assets.sfx.plim}',
            maxPlayers: 4,
            prefix: '',
          ),
        ).called(1);
      });

      test('configures the audio cache instance', () async {
        await audio.load();

        verify(() => configureAudioCache.onCall(FlameAudio.audioCache))
            .called(1);
      });

      test('sets the correct prefix', () async {
        audio = PinballAudio(
          createAudioPool: createAudioPool.onCall,
          playSingleAudio: playSingleAudio.onCall,
          preCacheSingleAudio: preCacheSingleAudio.onCall,
        );
        await audio.load();

        expect(FlameAudio.audioCache.prefix, equals(''));
      });

      test('pre cache the assets', () async {
        await audio.load();

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

    group('score', () {
      test('plays the score sound pool', () async {
        final audioPool = _MockAudioPool();
        when(audioPool.start).thenAnswer((_) async => () {});
        when(
          () => createAudioPool.onCall(
            any(),
            maxPlayers: any(named: 'maxPlayers'),
            prefix: any(named: 'prefix'),
          ),
        ).thenAnswer((_) async => audioPool);

        await audio.load();
        audio.score();

        verify(audioPool.start).called(1);
      });
    });

    group('googleBonus', () {
      test('plays the correct file', () async {
        await audio.load();
        audio.googleBonus();

        verify(
          () => playSingleAudio
              .onCall('packages/pinball_audio/${Assets.sfx.google}'),
        ).called(1);
      });
    });

    group('ioPinballVoiceOver', () {
      test('plays the correct file', () async {
        await audio.load();
        audio.ioPinballVoiceOver();

        verify(
          () => playSingleAudio.onCall(
            'packages/pinball_audio/${Assets.sfx.ioPinballVoiceOver}',
          ),
        ).called(1);
      });
    });

    group('backgroundMusic', () {
      test('plays the correct file', () async {
        await audio.load();
        audio.backgroundMusic();

        verify(
          () => loopSingleAudio
              .onCall('packages/pinball_audio/${Assets.music.background}'),
        ).called(1);
      });
    });
  });
}
