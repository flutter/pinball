import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/multiball/multiball_game.dart';

void addMultiballStories(Dashbook dashbook) {
  dashbook.storiesOf('Multiball').addGame(
        title: 'Assets',
        description: MultiballGame.description,
        gameBuilder: (_) => MultiballGame(),
      );
}
