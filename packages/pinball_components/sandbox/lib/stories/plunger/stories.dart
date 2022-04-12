import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/plunger/plunger_game.dart';

void addPlungerStories(Dashbook dashbook) {
  dashbook.storiesOf('Plunger').add(
        'Basic',
        (context) => GameWidget(
          game: PlungerGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('plunger_game/basic.dart'),
        info: PlungerGame.info,
      );
}
