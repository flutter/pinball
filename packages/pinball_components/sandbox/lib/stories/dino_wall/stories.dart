import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/dino_wall/dino_wall_game.dart';

void addDinoWallStories(Dashbook dashbook) {
  dashbook.storiesOf('DinoWall').addGame(
        title: 'Traced',
        description: DinoWallGame.description,
        gameBuilder: (_) => DinoWallGame(),
      );
}
