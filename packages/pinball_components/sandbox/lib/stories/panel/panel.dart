import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/panel/basic.dart';

void addPanelStories(Dashbook dashbook) {
  dashbook.storiesOf('Panel').add(
        'Basic',
        (context) => GameWidget(
          game: BasicPanelGame(),
        ),
        codeLink: buildSourceLink('panel/basic.dart'),
        info: BasicPanelGame.info,
      );
}
