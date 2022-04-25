import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/layer/layer_game.dart';

void addLayerStories(Dashbook dashbook) {
  dashbook.storiesOf('Layer').addGame(
        title: 'Example',
        description: LayerGame.description,
        gameBuilder: (_) => LayerGame(),
      );
}
