import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/effects/fire_effect_game.dart';

void addEffectsStories(Dashbook dashbook) {
  dashbook.storiesOf('Effects').add(
        'Fire Effect',
        (context) => GameWidget(game: FireEffectGame()),
        codeLink: buildSourceLink('effects/fire_effect.dart'),
        info: FireEffectGame.info,
      );
}
