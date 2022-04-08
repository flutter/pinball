import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/score_text_effect/basic.dart';

void addScoreTextEffectStories(Dashbook dashbook) {
  dashbook.storiesOf('ScoreTextEffect').add(
        'Basic',
        (context) => GameWidget(
          game: ScoreTextEffectBasicGame(),
        ),
        codeLink: buildSourceLink('score_text_effect/basic.dart'),
        info: ScoreTextEffectBasicGame.info,
      );
}
