import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/baseboard/baseboard_game.dart';

void addBaseboardStories(Dashbook dashbook) {
  dashbook.storiesOf('Baseboard').add(
        'Basic',
        (context) => GameWidget(
          game: BaseboardGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('baseboard_game/basic.dart'),
        info: BaseboardGame.info,
      );
}
