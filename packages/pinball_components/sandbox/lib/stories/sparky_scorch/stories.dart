import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/sparky_scorch/sparky_bumper_game.dart';
import 'package:sandbox/stories/sparky_scorch/sparky_computer_game.dart';

void addSparkyScorchStories(Dashbook dashbook) {
  dashbook.storiesOf('Sparky Scorch')
    ..addGame(
      title: 'Sparky Computer',
      description: SparkyComputerGame.description,
      gameBuilder: (_) => SparkyComputerGame(),
    )
    ..addGame(
      title: 'Sparky Bumper',
      description: SparkyBumperGame.description,
      gameBuilder: (_) => SparkyBumperGame(),
    );
}
