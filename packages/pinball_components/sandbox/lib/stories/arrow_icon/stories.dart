import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/arrow_icon/arrow_icon_game.dart';

void addArrowIconStories(Dashbook dashbook) {
  dashbook.storiesOf('ArrowIcon').addGame(
        title: 'Basic',
        description: ArrowIconGame.description,
        gameBuilder: (context) => ArrowIconGame(),
      );
}
