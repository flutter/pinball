import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/launch_ramp/launch_ramp_game.dart';

void addLaunchRampStories(Dashbook dashbook) {
  dashbook.storiesOf('LaunchRamp').add(
        'Basic',
        (context) => GameWidget(
          game: LaunchRampGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('launch_ramp/basic.dart'),
        info: LaunchRampGame.info,
      );
}
