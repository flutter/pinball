import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/sparky_bumper/sparky_bumper_game.dart';

void addSparkyBumperStories(Dashbook dashbook) {
  dashbook.storiesOf('Sparky Bumpers').addGame(
        title: 'Traced',
        description: SparkyBumperGame.description,
        gameBuilder: (_) => SparkyBumperGame(),
      );
}
