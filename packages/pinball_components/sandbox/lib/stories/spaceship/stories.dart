import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/spaceship/basic_spaceship_game.dart';

void addSpaceshipStories(Dashbook dashbook) {
  dashbook.storiesOf('Spaceship').addGame(
        title: 'Traced',
        description: BasicSpaceshipGame.info,
        gameBuilder: (_) => BasicSpaceshipGame(),
      );
}
