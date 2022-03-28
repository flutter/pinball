import 'package:dashbook/dashbook.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/layer/basic.dart';

void addLayerStories(Dashbook dashbook) {
  dashbook.storiesOf('Layer').add(
        'Layer',
        (context) => GameWidget(
          game: BasicLayerGame(
            color: context.colorProperty('color', Colors.blue),
          ),
        ),
        codeLink: buildSourceLink('layer/basic.dart'),
        info: BasicLayerGame.info,
      );
}
