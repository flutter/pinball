import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/slingshot/slingshot_game.dart';

void addSlingshotStories(Dashbook dashbook) {
  dashbook.storiesOf('Slingshots').add(
        'Basic',
        (context) => GameWidget(
          game: SlingshotGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('slingshot_game/basic.dart'),
        info: SlingshotGame.info,
      );
}
