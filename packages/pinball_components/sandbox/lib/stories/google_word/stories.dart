import 'package:dashbook/dashbook.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/google_word/google_letter_game.dart';

void addGoogleWordStories(Dashbook dashbook) {
  dashbook.storiesOf('Google Word').addGame(
        title: 'Letter 0',
        description: GoogleLetterGame.description,
        gameBuilder: (_) => GoogleLetterGame(),
      );
}
