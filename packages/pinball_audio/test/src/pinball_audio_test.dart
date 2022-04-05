// ignore_for_file: prefer_const_constructors
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_audio/gen/assets.gen.dart';
import 'package:pinball_audio/pinball_audio.dart';

import '../helpers/helpers.dart';

void main() {
  group('PinballAudio', () {
    test('can be instantiated', () {
      expect(PinballAudio(), isNotNull);
    });

    late CreateAudioPoolStub createAudioPool;
    late ConfigureAudioCacheStub configureAudioCache;
    late PlaySingleAudioStub playSingleAudio;
    late PinballAudio audio;

    setUpAll(() {
      registerFallbackValue(MockAudioCache());
    });

    setUp(() {
      createAudioPool = CreateAudioPoolStub();
      when(
        () => createAudioPool.onCall(
          any(),
          maxPlayers: any(named: 'maxPlayers'),
          prefix: any(named: 'prefix'),
        ),
      ).thenAnswer((_) async => MockAudioPool());

      configureAudioCache = ConfigureAudioCacheStub();
      when(() => configureAudioCache.onCall(any())).thenAnswer((_) {});

      playSingleAudio = PlaySingleAudioStub();
      when(() => playSingleAudio.onCall(any())).thenAnswer((_) async {});

      audio = PinballAudio(
        configureAudioCache: configureAudioCache.onCall,
        createAudioPool: createAudioPool.onCall,
        playSingleAudio: playSingleAudio.onCall,
      );
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
        );
        await audio.load();

        expect(FlameAudio.audioCache.prefix, equals(''));
      });
    });

    group('score', () {
      test('plays the score sound pool', () async {
        final audioPool = MockAudioPool();
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
  });
}
