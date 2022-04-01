import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/camera/zoom.dart';

void addCameraStories(Dashbook dashbook) {
  dashbook.storiesOf('Camera').add(
        'Zoom',
        (context) => GameWidget(
          game: ZoomCameraGame(),
        ),
        codeLink: buildSourceLink('panel/zoom.dart'),
        info: ZoomCameraGame.info,
      );
}
