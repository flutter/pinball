import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/alien_zone/alien_bumper_a_game.dart';
import 'package:sandbox/stories/alien_zone/alien_bumper_b_game.dart';

void addAlienZoneStories(Dashbook dashbook) {
  dashbook.storiesOf('Alien Zone')
    ..addGame(
      title: 'Alien Bumper A',
      description: AlienBumperAGame.info,
      gameBuilder: (_) => AlienBumperAGame(),
    )
    ..addGame(
      title: 'Alien Bumper B',
      description: AlienBumperBGame.info,
      gameBuilder: (_) => AlienBumperBGame(),
    );
}
