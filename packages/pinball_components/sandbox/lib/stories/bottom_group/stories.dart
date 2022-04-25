import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/bottom_group/baseboard_game.dart';
import 'package:sandbox/stories/bottom_group/flipper_game.dart';
import 'package:sandbox/stories/bottom_group/kicker_game.dart';

void addBottomGroupStories(Dashbook dashbook) {
  dashbook.storiesOf('Bottom Group')
    ..add(
      'Flipper',
      (context) => GameWidget(
        game: FlipperGame()..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('bottom_group/flipper.dart'),
      info: FlipperGame.info,
    )
    ..add(
      'Kicker',
      (context) => GameWidget(
        game: KickerGame()..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('bottom_group/kicker.dart'),
      info: KickerGame.info,
    )
    ..add(
      'Baseboard',
      (context) => GameWidget(
        game: BaseboardGame()..trace = context.boolProperty('Trace', true),
      ),
      codeLink: buildSourceLink('bottom_group/baseboard.dart'),
      info: BaseboardGame.info,
    );
}
