import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/spaceship_ramp/spaceship_ramp_game.dart';

void addSpaceshipRampStories(Dashbook dashbook) {
  dashbook.storiesOf('SpaceshipRamp').add(
        'Basic',
        (context) => GameWidget(
          game: SpaceshipRampGame()
            ..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('spaceship_ramp/basic.dart'),
        info: SpaceshipRampGame.info,
      );
}
