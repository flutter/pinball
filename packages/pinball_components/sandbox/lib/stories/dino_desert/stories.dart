import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/dino_desert/chrome_dino_game.dart';
import 'package:sandbox/stories/dino_desert/dino_walls_game.dart';
import 'package:sandbox/stories/dino_desert/slingshots_game.dart';

void addDinoDesertStories(Dashbook dashbook) {
  dashbook.storiesOf('Dino Desert')
    ..addGame(
      title: 'Chrome Dino',
      description: ChromeDinoGame.description,
      gameBuilder: (_) => ChromeDinoGame(),
    )
    ..addGame(
      title: 'Dino Walls',
      description: DinoWallsGame.description,
      gameBuilder: (_) => DinoWallsGame(),
    )
    ..addGame(
      title: 'Slingshots',
      description: SlingshotsGame.description,
      gameBuilder: (_) => SlingshotsGame(),
    );
}
