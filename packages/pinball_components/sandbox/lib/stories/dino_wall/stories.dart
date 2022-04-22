import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/dino_wall/dino_wall_game.dart';

void addDinoWallStories(Dashbook dashbook) {
  dashbook.storiesOf('DinoWall').add(
        'Basic',
        (context) => GameWidget(
          game: DinoWallGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('dino_wall/basic.dart'),
        info: DinoWallGame.info,
      );
}
