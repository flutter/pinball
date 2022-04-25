import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/baseboard/baseboard_game.dart';

void addBaseboardStories(Dashbook dashbook) {
  dashbook.storiesOf('Baseboard').addGame(
        title: 'Traced',
        description: BaseboardGame.description,
        gameBuilder: (_) => BaseboardGame(),
      );
}
