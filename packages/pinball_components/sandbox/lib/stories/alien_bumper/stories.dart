import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/alien_bumper/alien_bumper_game.dart';

void addAlienBumperStories(Dashbook dashbook) {
  dashbook.storiesOf('Alien Bumpers').add(
        'Basic',
        (context) => GameWidget(
          game: AlienBumperGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('alien_bumper/basic.dart'),
        info: AlienBumperGame.info,
      );
}
