import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/backboard/game_over.dart';
import 'package:sandbox/stories/backboard/waiting.dart';

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
          context.numberProperty('score', 9000000000).toInt(),
        ),
      ),
      codeLink: buildSourceLink('backboard/game_over.dart'),
      info: BackboardGameOverGame.info,
    );
}
