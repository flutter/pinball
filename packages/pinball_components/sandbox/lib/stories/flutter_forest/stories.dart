import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/flutter_forest/big_dash_bumper_game.dart';
import 'package:sandbox/stories/flutter_forest/signpost_game.dart';
import 'package:sandbox/stories/flutter_forest/small_dash_bumper_a_game.dart';
import 'package:sandbox/stories/flutter_forest/small_dash_bumper_b_game.dart';

void addFlutterForestStories(Dashbook dashbook) {
  dashbook.storiesOf('Flutter Forest')
    ..addGame(
      title: 'Signpost',
      description: SignpostGame.description,
      gameBuilder: (_) => SignpostGame(),
    )
    ..addGame(
      title: 'Big Dash Bumper',
      description: BigDashBumperGame.description,
      gameBuilder: (_) => BigDashBumperGame(),
    )
    ..addGame(
      title: 'Small Dash Bumper A',
      description: SmallDashBumperAGame.description,
      gameBuilder: (_) => SmallDashBumperAGame(),
    )
    ..addGame(
      title: 'Small Dash Bumper B',
      description: SmallDashBumperBGame.description,
      gameBuilder: (_) => SmallDashBumperBGame(),
    );
}
