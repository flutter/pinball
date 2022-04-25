import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/effects/camera_zoom_game.dart';
import 'package:sandbox/stories/effects/fire_effect_game.dart';

void addEffectsStories(Dashbook dashbook) {
  dashbook.storiesOf('Effects')
    ..addGame(
      title: 'Fire',
      description: FireEffectGame.description,
      gameBuilder: (_) => FireEffectGame(),
    )
    ..addGame(
      title: 'CameraZoom',
      description: CameraZoomGame.description,
      gameBuilder: (_) => CameraZoomGame(),
    );
}
