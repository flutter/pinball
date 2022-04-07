import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';
import 'package:sandbox/stories/dash_nest_bumper/big_dash_nest_bumper_game.dart';

void addDashNestBumperStories(Dashbook dashbook) {
  dashbook.storiesOf('Dash Nest Bumpers').add(
        'Big',
        (context) => GameWidget(
          game: BigDashNestBumperGame()
            ..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('dash_nest_bumper/big.dart'),
        info: BasicBallGame.info,
      );
}
