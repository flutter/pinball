import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/plunger/plunger_game.dart';

void addPlungerStories(Dashbook dashbook) {
  dashbook.storiesOf('Plunger').addGame(
        title: 'Traced',
        description: PlungerGame.description,
        gameBuilder: (_) => PlungerGame(),
      );
}
