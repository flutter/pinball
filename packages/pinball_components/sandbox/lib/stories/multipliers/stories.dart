import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/multipliers/multipliers_game.dart';

void addMultipliersStories(Dashbook dashbook) {
  dashbook.storiesOf('Multipliers').addGame(
        title: 'Multipliers',
        description: MultipliersGame.description,
        gameBuilder: (_) => MultipliersGame(),
      );
}
