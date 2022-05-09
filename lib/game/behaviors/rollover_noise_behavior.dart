// ignore_for_file: public_member_api_docs

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_flame/pinball_flame.dart';

class RolloverNoiseBehavior extends ContactBehavior {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    readProvider<PinballAudioPlayer>().play(PinballAudio.rollover);
  }
}
