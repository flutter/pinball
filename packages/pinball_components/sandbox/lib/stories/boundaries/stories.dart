import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/boundaries/boundaries_game.dart';

void addBoundariesStories(Dashbook dashbook) {
  dashbook.storiesOf('Boundaries').add(
        'Basic',
        (context) => GameWidget(
          game: BoundariesGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('boundaries_game/basic.dart'),
        info: BoundariesGame.info,
      );
}
