import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/boundaries/boundaries_game.dart';

void addBoundariesStories(Dashbook dashbook) {
  dashbook.storiesOf('Boundaries').addGame(
        title: 'Traced',
        description: BoundariesGame.description,
        gameBuilder: (_) => BoundariesGame(),
      );
}
