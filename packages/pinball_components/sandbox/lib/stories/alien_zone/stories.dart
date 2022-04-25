import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/alien_zone/alien_bumper_a_game.dart';
import 'package:sandbox/stories/alien_zone/alien_bumper_b_game.dart';
import 'package:sandbox/stories/alien_zone/spaceship_game.dart';
import 'package:sandbox/stories/alien_zone/spaceship_rail_game.dart';
import 'package:sandbox/stories/alien_zone/spaceship_ramp_game.dart';

void addAlienZoneStories(Dashbook dashbook) {
  dashbook.storiesOf('Alien Zone')
    ..addGame(
      title: 'Alien Bumper A',
      description: AlienBumperAGame.description,
      gameBuilder: (_) => AlienBumperAGame(),
    )
    ..addGame(
      title: 'Alien Bumper B',
      description: AlienBumperBGame.description,
      gameBuilder: (_) => AlienBumperBGame(),
    )
    ..addGame(
      title: 'Spaceship',
      description: SpaceshipGame.description,
      gameBuilder: (_) => SpaceshipGame(),
    )
    ..addGame(
      title: 'Spaceship Rail',
      description: SpaceshipRailGame.description,
      gameBuilder: (_) => SpaceshipRailGame(),
    )
    ..addGame(
      title: 'Spaceship Ramp',
      description: SpaceshipRampGame.description,
      gameBuilder: (_) => SpaceshipRampGame(),
    );
}
