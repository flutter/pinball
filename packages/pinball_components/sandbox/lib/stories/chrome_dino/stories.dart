import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/chrome_dino/chrome_dino_game.dart';

void addChromeDinoStories(Dashbook dashbook) {
  dashbook.storiesOf('Chrome Dino').addGame(
        title: 'Trace',
        description: ChromeDinoGame.description,
        gameBuilder: (_) => ChromeDinoGame(),
      );
}
