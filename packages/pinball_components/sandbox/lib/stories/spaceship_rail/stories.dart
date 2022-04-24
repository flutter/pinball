import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/spaceship_rail/spaceship_rail_game.dart';

void addSpaceshipRailStories(Dashbook dashbook) {
  dashbook.storiesOf('SpaceshipRail').addGame(
        title: 'Traced',
        description: SpaceshipRailGame.description,
        gameBuilder: (_) => SpaceshipRailGame(),
      );
}
