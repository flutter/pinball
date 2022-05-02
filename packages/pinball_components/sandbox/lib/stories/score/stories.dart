import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/score/score_game.dart';

void addScoreStories(Dashbook dashbook) {
  dashbook.storiesOf('Score').addGame(
        title: 'Basic',
        description: ScoreGame.description,
        gameBuilder: (_) => ScoreGame(),
      );
}
