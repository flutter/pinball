import 'dart:math';

import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';

class ScoreGame extends AssetsGame with TapDetector {
  ScoreGame()
      : super(
          imagesFileNames: [
            Assets.images.score.points5k.keyName,
            Assets.images.score.points10k.keyName,
            Assets.images.score.points15k.keyName,
            Assets.images.score.points20k.keyName,
            Assets.images.score.points25k.keyName,
            Assets.images.score.points30k.keyName,
            Assets.images.score.points40k.keyName,
            Assets.images.score.points50k.keyName,
            Assets.images.score.points60k.keyName,
            Assets.images.score.points80k.keyName,
            Assets.images.score.points100k.keyName,
            Assets.images.score.points120k.keyName,
            Assets.images.score.points200k.keyName,
            Assets.images.score.points400k.keyName,
            Assets.images.score.points600k.keyName,
            Assets.images.score.points800k.keyName,
            Assets.images.score.points1m.keyName,
            Assets.images.score.points1m2.keyName,
            Assets.images.score.points2m.keyName,
            Assets.images.score.points3m.keyName,
            Assets.images.score.points4m.keyName,
            Assets.images.score.points5m.keyName,
            Assets.images.score.points6m.keyName,
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
    camera.followVector2(Vector2.zero());
  }

  @override
  void onTapUp(TapUpInfo info) {
    final index = random.nextInt(Points.values.length);
    final score = Points.values[index];

    add(
      ScoreComponent(
        points: score,
        position: info.eventPosition.game..multiply(Vector2(1, -1)),
      ),
    );
  }
}
