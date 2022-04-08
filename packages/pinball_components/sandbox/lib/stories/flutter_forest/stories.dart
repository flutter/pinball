import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/flutter_forest/big_dash_nest_bumper_game.dart';
import 'package:sandbox/stories/flutter_forest/flutter_sign_post_game.dart';
import 'package:sandbox/stories/flutter_forest/small_dash_nest_bumper_a_game.dart';
import 'package:sandbox/stories/flutter_forest/small_dash_nest_bumper_b_game.dart';

void addDashNestBumperStories(Dashbook dashbook) {
  dashbook.storiesOf('Flutter Forest')
    ..add(
      'Flutter Sign Post',
      (context) => GameWidget(
        game: FlutterSignPostGame()
          ..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('flutter_forest/flutter_sign_post.dart'),
      info: FlutterSignPostGame.info,
    )
    ..add(
      'Big Dash Nest Bumper',
      (context) => GameWidget(
        game: BigDashNestBumperGame()
          ..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('flutter_forest/big_dash_nest_bumper.dart'),
      info: BigDashNestBumperGame.info,
    )
    ..add(
      'Small Dash Nest Bumper A',
      (context) => GameWidget(
        game: SmallDashNestBumperAGame()
          ..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('flutter_forest/small_dash_nest_bumper_a.dart'),
      info: SmallDashNestBumperAGame.info,
    )
    ..add(
      'Small Dash Nest Bumper B',
      (context) => GameWidget(
        game: SmallDashNestBumperBGame()
          ..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('flutter_forest/small_dash_nest_bumper_b.dart'),
      info: SmallDashNestBumperBGame.info,
    );
}
