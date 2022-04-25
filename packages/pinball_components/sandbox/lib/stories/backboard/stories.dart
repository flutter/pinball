import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/backboard/backboard_game_over_game.dart';
import 'package:sandbox/stories/backboard/backboard_waiting_game.dart';

void addBackboardStories(Dashbook dashbook) {
  dashbook.storiesOf('Backboard')
    ..addGame(
      title: 'Waiting',
      description: BackboardWaitingGame.description,
      gameBuilder: (_) => BackboardWaitingGame(),
    )
    ..addGame(
      title: 'Game over',
      description: BackboardGameOverGame.description,
      gameBuilder: (context) => BackboardGameOverGame(
        context.numberProperty('Score', 9000000000).toInt(),
        context.listProperty(
          'Character',
          BackboardGameOverGame.characterIconPaths.keys.first,
          BackboardGameOverGame.characterIconPaths.keys.toList(),
        ),
      ),
    );
}
