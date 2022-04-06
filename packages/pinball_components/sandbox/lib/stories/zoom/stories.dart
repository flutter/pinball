import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/zoom/basic_zoom_game.dart';

void addZoomStories(Dashbook dashbook) {
  dashbook.storiesOf('CameraZoom').add(
        'Basic',
        (context) => GameWidget(
          game: BasicCameraZoomGame(),
        ),
        codeLink: buildSourceLink('zoom/basic_zoom_game.dart'),
        info: BasicCameraZoomGame.info,
      );
}
