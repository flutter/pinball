import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/spaceship_ramp/spaceship_ramp_game.dart';

void addSpaceshipRampStories(Dashbook dashbook) {
  dashbook.storiesOf('SpaceshipRamp').addGame(
        title: 'Traced',
        description: SpaceshipRampGame.description,
        gameBuilder: (_) => SpaceshipRampGame(),
      );
}
