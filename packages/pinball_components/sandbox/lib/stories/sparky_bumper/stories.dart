import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/sparky_bumper/sparky_bumper_game.dart';

void addSparkyBumperStories(Dashbook dashbook) {
  dashbook.storiesOf('Sparky Bumpers').add(
        'Basic',
        (context) => GameWidget(
          game: SparkyBumperGame(
            trace: context.boolProperty('Trace', true),
          ),
        ),
        codeLink: buildSourceLink('sparky_bumper/basic.dart'),
        info: SparkyBumperGame.info,
      );
}
