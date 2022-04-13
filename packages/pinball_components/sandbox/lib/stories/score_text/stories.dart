import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/score_text/basic.dart';

void addScoreTextStories(Dashbook dashbook) {
  dashbook.storiesOf('ScoreText').add(
        'Basic',
        (context) => GameWidget(
          game: ScoreTextBasicGame(),
        ),
        codeLink: buildSourceLink('score_text/basic.dart'),
        info: ScoreTextBasicGame.info,
      );
}
