import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/backboard/backboard_game_over_game.dart';
import 'package:sandbox/stories/backboard/backboard_waiting_game.dart';

void addBackboardStories(Dashbook dashbook) {
  dashbook.storiesOf('Backboard')
    ..add(
      'Waiting mode',
      (context) => GameWidget(
        game: BackboardWaitingGame(),
      ),
      codeLink: buildSourceLink('backboard/waiting.dart'),
      info: BackboardWaitingGame.info,
    )
    ..add(
      'Game over',
      (context) => GameWidget(
        game: BackboardGameOverGame(
          context.numberProperty('Score', 9000000000).toInt(),
          context.listProperty(
            'Character',
            BackboardGameOverGame.characterIconPaths.keys.first,
            BackboardGameOverGame.characterIconPaths.keys.toList(),
          ),
        ),
      ),
      codeLink: buildSourceLink('backboard/game_over.dart'),
      info: BackboardGameOverGame.info,
    );
}
