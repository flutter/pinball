import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/android_acres/android_bumper_a_game.dart';
import 'package:sandbox/stories/android_acres/android_bumper_b_game.dart';
import 'package:sandbox/stories/android_acres/spaceship_game.dart';
import 'package:sandbox/stories/android_acres/spaceship_rail_game.dart';
import 'package:sandbox/stories/android_acres/spaceship_ramp_game.dart';

void addAndroidAcresStories(Dashbook dashbook) {
  dashbook.storiesOf('Android Acres')
    ..addGame(
      title: 'Android Bumper A',
      description: AndroidBumperAGame.description,
      gameBuilder: (_) => AndroidBumperAGame(),
    )
    ..addGame(
      title: 'Android Bumper B',
      description: AndroidBumperBGame.description,
      gameBuilder: (_) => AndroidBumperBGame(),
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
