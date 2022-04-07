import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/spaceship_rail/spaceship_rail_game.dart';

void addSpaceshipRailStories(Dashbook dashbook) {
  dashbook.storiesOf('SpaceshipRail').add(
        'Basic',
        (context) => GameWidget(
          game: SpaceshipRailGame()
            ..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('spaceship_rail/basic.dart'),
        info: SpaceshipRailGame.info,
      );
}
