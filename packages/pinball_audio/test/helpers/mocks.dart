// ignore_for_file: one_member_abstracts

import 'package:audioplayers/audioplayers.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:mocktail/mocktail.dart';

abstract class _CreateAudioPoolStub {
  Future<AudioPool> onCall(
    String sound, {
    bool? repeating,
    int? maxPlayers,
    int? minPlayers,
    String? prefix,
  });
}

class CreateAudioPoolStub extends Mock implements _CreateAudioPoolStub {}

abstract class _ConfigureAudioCacheStub {
  void onCall(AudioCache cache);
}

class ConfigureAudioCacheStub extends Mock implements _ConfigureAudioCacheStub {
}

abstract class _PlaySingleAudioStub {
  Future<void> onCall(String url);
}

class PlaySingleAudioStub extends Mock implements _PlaySingleAudioStub {}

class MockAudioPool extends Mock implements AudioPool {}

class MockAudioCache extends Mock implements AudioCache {}
