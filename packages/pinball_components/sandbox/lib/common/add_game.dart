import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:sandbox/common/common.dart';

const _path =
    'https://github.com/flutter/pinball/tree/main/packages/pinball_components/sandbox/lib/stories/';

extension StoryAddGame on Story {
  void addGame({
    required String title,
    required String description,
    required Game Function(DashbookContext) gameBuilder,
  }) {
    final _chapter = Chapter(
      title,
      (DashbookContext context) {
        final game = gameBuilder(context);
        if (game is Traceable) {
          game.trace = context.boolProperty('Trace', true);
        }

        return GameWidget(game: game);
      },
      this,
      codeLink: '$_path${name.toPath()}/${title.toPath()}',
      info: description,
    );
    chapters.add(_chapter);
  }
}

extension on String {
  String toPath() {
    return replaceAll(' ', '_')..toLowerCase();
  }
}
