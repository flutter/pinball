import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/score_text/score_text_game.dart';

void addScoreTextStories(Dashbook dashbook) {
  dashbook.storiesOf('ScoreText').addGame(
        title: 'Basic',
        description: ScoreTextGame.description,
        gameBuilder: (_) => ScoreTextGame(),
      );
}
