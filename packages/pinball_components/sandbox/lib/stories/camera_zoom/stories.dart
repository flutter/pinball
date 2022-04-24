import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/camera_zoom/camera_zoom_game.dart';

void addZoomStories(Dashbook dashbook) {
  dashbook.storiesOf('CameraZoom').addGame(
        title: 'Example',
        description: CameraZoomGame.info,
        gameBuilder: (_) => CameraZoomGame(),
      );
}
