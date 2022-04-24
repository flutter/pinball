import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/flutter_forest/big_dash_nest_bumper_game.dart';
import 'package:sandbox/stories/flutter_forest/signpost_game.dart';
import 'package:sandbox/stories/flutter_forest/small_dash_nest_bumper_a_game.dart';
import 'package:sandbox/stories/flutter_forest/small_dash_nest_bumper_b_game.dart';

void addDashNestBumperStories(Dashbook dashbook) {
  dashbook.storiesOf('Flutter Forest')
    ..addGame(
      title: 'Signpost',
      description: SignpostGame.info,
      gameBuilder: (_) => SignpostGame(),
    )
    ..addGame(
      title: 'Big Dash Nest Bumper',
      description: BigDashNestBumperGame.info,
      gameBuilder: (_) => BigDashNestBumperGame(),
    )
    ..addGame(
      title: 'Small Dash Nest Bumper A',
      description: SmallDashNestBumperAGame.info,
      gameBuilder: (_) => SmallDashNestBumperAGame(),
    )
    ..addGame(
      title: 'Small Dash Nest Bumper B',
      description: SmallDashNestBumperBGame.info,
      gameBuilder: (_) => SmallDashNestBumperBGame(),
    );
}
