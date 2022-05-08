import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/effects/camera_zoom_game.dart';

void addEffectsStories(Dashbook dashbook) {
  dashbook.storiesOf('Effects').addGame(
        title: 'CameraZoom',
        description: CameraZoomGame.description,
        gameBuilder: (_) => CameraZoomGame(),
      );
}
