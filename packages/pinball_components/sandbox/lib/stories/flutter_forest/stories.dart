import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/flutter_forest/dash_bumper_a_game.dart';
import 'package:sandbox/stories/flutter_forest/dash_bumper_b_game.dart';
import 'package:sandbox/stories/flutter_forest/dash_bumper_main_game.dart';
import 'package:sandbox/stories/flutter_forest/signpost_game.dart';

void addFlutterForestStories(Dashbook dashbook) {
  dashbook.storiesOf('Flutter Forest')
    ..addGame(
      title: 'Signpost',
      description: SignpostGame.description,
      gameBuilder: (_) => SignpostGame(),
    )
    ..addGame(
      title: 'Main Dash Bumper',
      description: DashBumperMainGame.description,
      gameBuilder: (_) => DashBumperMainGame(),
    )
    ..addGame(
      title: 'Dash Bumper A',
      description: DashBumperAGame.description,
      gameBuilder: (_) => DashBumperAGame(),
    )
    ..addGame(
      title: 'Dash Bumper B',
      description: DashBumperBGame.description,
      gameBuilder: (_) => DashBumperBGame(),
    );
}
