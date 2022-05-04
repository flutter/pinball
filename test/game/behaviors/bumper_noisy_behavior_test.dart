// ignore_for_file: cascade_invocations

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/behaviors/behaviors.dart';
import 'package:pinball_audio/pinball_audio.dart';

import '../../helpers/helpers.dart';

class _TestBodyComponent extends BodyComponent {
  @override
  Body createBody() {
    return world.createBody(BodyDef());
  }
}

class _MockPinballAudio extends Mock implements PinballAudio {}

class _MockContact extends Mock implements Contact {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BumperNoisyBehavior', () {});

  late PinballAudio audio;
  final flameTester = FlameTester(
    () => EmptyPinballTestGame(audio: audio),
  );

  setUp(() {
    audio = _MockPinballAudio();
  });

  flameTester.testGameWidget(
    'plays bumper sound',
    setUp: (game, _) async {
      final behavior = BumperNoisyBehavior();
      final parent = _TestBodyComponent();
      await game.ensureAdd(parent);
      await parent.ensureAdd(behavior);
      behavior.beginContact(Object(), _MockContact());
    },
    verify: (_, __) async {
      verify(audio.bumper).called(1);
    },
  );
}
