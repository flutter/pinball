import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class ScoreGame extends AssetsGame with TapDetector {
  ScoreGame()
      : super(
          imagesFileNames: [
            Assets.images.score.fiveThousand.keyName,
            Assets.images.score.twentyThousand.keyName,
            Assets.images.score.twoHundredThousand.keyName,
            Assets.images.score.oneMillion.keyName,
          ],
        );

  static const description = '''
    Simple game to show how score component works,

    - Tap anywhere on the screen to spawn an image on the given location.
''';

  final random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.follow(PositionComponent(position: Vector2.zero()));
  }

  @override
  void onTapUp(TapUpInfo info) {
    final index = random.nextInt(Points.values.length);
    final score = Points.values[index];

    add(
      ScoreComponent(
        points: score,
        position: info.eventPosition.global..multiply(Vector2(1, -1)),
        effectController: EffectController(duration: 1),
      ),
    );
  }
}
