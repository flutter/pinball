import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/flipper/flipper_game.dart';

void addFlipperStories(Dashbook dashbook) {
  dashbook.storiesOf('Flipper').addGame(
        title: 'Traced',
        description: FlipperGame.description,
        gameBuilder: (_) => FlipperGame(),
      );
}
