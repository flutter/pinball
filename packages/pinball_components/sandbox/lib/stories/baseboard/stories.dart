import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/baseboard/basic_baseboard_game.dart';

void addBaseboardStories(Dashbook dashbook) {
  dashbook.storiesOf('Baseboard').add(
        'Basic',
        (context) => GameWidget(
          game: BasicBaseboardGame(),
        ),
        codeLink: buildSourceLink('baseboard/basic.dart'),
        info: BasicBaseboardGame.info,
      );
}
