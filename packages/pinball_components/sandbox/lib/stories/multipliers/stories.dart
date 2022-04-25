import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/multipliers/multipliers_game.dart';

void addMultipliersStories(Dashbook dashbook) {
  dashbook.storiesOf('Multipliers').add(
        'Basic',
        (context) => GameWidget(
          game: MultipliersGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('multiplier/basic.dart'),
        info: MultipliersGame.info,
      );
}
