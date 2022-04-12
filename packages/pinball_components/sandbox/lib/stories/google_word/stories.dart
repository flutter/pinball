import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/google_word/google_letter_game.dart';

void addGoogleWordStories(Dashbook dashbook) {
  dashbook.storiesOf('Google Word').add(
        'Letter',
        (context) => GameWidget(
          game: GoogleLetterGame()..trace = context.boolProperty('Trace', true),
        ),
        codeLink: buildSourceLink('google_word/letter.dart'),
        info: GoogleLetterGame.info,
      );
}
