import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/backboard/game_over.dart';
import 'package:sandbox/stories/backboard/waiting.dart';

void addBackboardStories(Dashbook dashbook) {
  final characters = ['Dash', 'Sparky', 'Android', 'Dino'];
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
            characters.first,
            characters,
          ),
        ),
      ),
      codeLink: buildSourceLink('backboard/game_over.dart'),
      info: BackboardGameOverGame.info,
    );
}
