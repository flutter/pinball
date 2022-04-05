import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/kicker/kicker_game.dart';

void addKickerStories(Dashbook dashbook) {
  dashbook.storiesOf('Kickers').add(
        'Basic',
        (context) => GameWidget(
          game: KickerGame(
            trace: context.boolProperty('Trace', true),
          ),
        ),
        codeLink: buildSourceLink('kicker_game/basic.dart'),
        info: KickerGame.info,
      );
}
