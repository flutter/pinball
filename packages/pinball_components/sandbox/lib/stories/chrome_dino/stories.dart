import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/chrome_dino/chrome_dino_game.dart';

void addChromeDinoStories(Dashbook dashbook) {
  dashbook.storiesOf('Chrome Dino').add(
        'Basic',
        (context) => GameWidget(
          game: ChromeDinoGame(),
        ),
        codeLink: buildSourceLink('chrome_dino/basic.dart'),
        info: ChromeDinoGame.info,
      );
}
