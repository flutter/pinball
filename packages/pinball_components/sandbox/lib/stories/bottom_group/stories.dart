import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/bottom_group/baseboard_game.dart';
import 'package:sandbox/stories/bottom_group/flipper_game.dart';
import 'package:sandbox/stories/bottom_group/kicker_game.dart';

void addBottomGroupStories(Dashbook dashbook) {
  dashbook.storiesOf('Bottom Group')
    ..addGame(
      title: 'Flipper',
      description: FlipperGame.description,
      gameBuilder: (_) => FlipperGame(),
    )
    ..addGame(
      title: 'Kicker',
      description: KickerGame.description,
      gameBuilder: (_) => KickerGame(),
    )
    ..addGame(
      title: 'Baseboard',
      description: BaseboardGame.description,
      gameBuilder: (_) => BaseboardGame(),
    );
}
