import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/ball_booster_game.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

void addBallStories(Dashbook dashbook) {
  dashbook.storiesOf('Ball')
    ..addGame(
      title: 'Themed',
      description: BallGame.description,
      gameBuilder: (context) => BallGame(
        character: context.listProperty(
          'Character',
          BallGame.characterBallPaths.keys.first,
          BallGame.characterBallPaths.keys.toList(),
        ),
      ),
    )
    ..addGame(
      title: 'Booster',
      description: BallBoosterGame.description,
      gameBuilder: (context) => BallBoosterGame(),
    );
}
