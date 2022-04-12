import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/alien_zone/alien_bumper_a_game.dart';
import 'package:sandbox/stories/alien_zone/alien_bumper_b_game.dart';

void addAlienZoneStories(Dashbook dashbook) {
  dashbook.storiesOf('Alien Zone')
    ..add(
      'Alien Bumper A',
      (context) => GameWidget(
        game: AlienBumperAGame()..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('alien_zone/alien_bumper_a.dart'),
      info: AlienBumperAGame.info,
    )
    ..add(
      'Alien Bumper B',
      (context) => GameWidget(
        game: AlienBumperBGame()..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('alien_zone/alien_bumper_b.dart'),
      info: AlienBumperAGame.info,
    );
}
