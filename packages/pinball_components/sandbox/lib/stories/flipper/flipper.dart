import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/flipper/basic.dart';

void addFlipperStories(Dashbook dashbook) {
  dashbook.storiesOf('Flipper').add(
        'Basic',
        (context) => GameWidget(
          game: BasicFlipperGame(),
        ),
        codeLink: buildSourceLink('ball/basic.dart'),
        info: BasicFlipperGame.info,
      );
}
