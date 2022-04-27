import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/launch_ramp/launch_ramp_game.dart';

void addLaunchRampStories(Dashbook dashbook) {
  dashbook.storiesOf('LaunchRamp').addGame(
        title: 'Traced',
        description: LaunchRampGame.description,
        gameBuilder: (_) => LaunchRampGame(),
      );
}
