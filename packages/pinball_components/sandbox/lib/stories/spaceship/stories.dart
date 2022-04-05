import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/spaceship/basic_spaceship_game.dart';

void addSpaceshipStories(Dashbook dashbook) {
  dashbook.storiesOf('Spaceship').add(
        'Basic',
        (context) => GameWidget(
          game: BasicSpaceshipGame(),
        ),
        codeLink: buildSourceLink('spaceship/basic.dart'),
        info: BasicSpaceshipGame.info,
      );
}
