import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/flipper/basic_flipper_game.dart';
import 'package:sandbox/stories/flipper/flipper_tracing_game.dart';

void addFlipperStories(Dashbook dashbook) {
  dashbook.storiesOf('Flipper')
    ..add(
      'Basic',
      (context) => GameWidget(
        game: BasicFlipperGame(),
      ),
      codeLink: buildSourceLink('flipper/basic.dart'),
      info: BasicFlipperGame.info,
    )
    ..add(
      'Tracing',
      (context) => GameWidget(
        game: FlipperTracingGame(),
      ),
      codeLink: buildSourceLink('flipper/tracing.dart'),
      info: FlipperTracingGame.info,
    );
}
