import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/spaceship/basic.dart';

void addSpaceshipStories(Dashbook dashbook) {
  dashbook.storiesOf('Spaceship').add(
        'Basic',
        (context) => GameWidget(game: BasicSpaceship()),
        codeLink: buildSourceLink('spaceship/basic.dart'),
        info: BasicSpaceship.info,
      );
}
