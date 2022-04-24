import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/kicker/kicker_game.dart';

void addKickerStories(Dashbook dashbook) {
  dashbook.storiesOf('Kickers').addGame(
        title: 'Traced',
        description: KickerGame.description,
        gameBuilder: (_) => KickerGame(),
      );
}
