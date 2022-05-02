import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/android_acres/android_bumper_a_game.dart';
import 'package:sandbox/stories/android_acres/android_bumper_b_game.dart';
import 'package:sandbox/stories/android_acres/android_bumper_cow_game.dart';
import 'package:sandbox/stories/android_acres/android_spaceship_game.dart';
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
      title: 'Android Bumper Cow',
      description: AndroidBumperCowGame.description,
      gameBuilder: (_) => AndroidBumperCowGame(),
    )
    ..addGame(
      title: 'Android Spaceship',
      description: AndroidSpaceshipGame.description,
      gameBuilder: (_) => AndroidSpaceshipGame(),
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
