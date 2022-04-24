import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/slingshot/slingshot_game.dart';

void addSlingshotStories(Dashbook dashbook) {
  dashbook.storiesOf('Slingshots').addGame(
        title: 'Traced',
        description: SlingshotGame.description,
        gameBuilder: (_) => SlingshotGame(),
      );
}
