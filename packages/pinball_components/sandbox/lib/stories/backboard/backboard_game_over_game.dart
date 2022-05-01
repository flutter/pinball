import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart' as components;
import 'package:pinball_theme/pinball_theme.dart';
import 'package:sandbox/common/common.dart';

class BackboardGameOverGame extends AssetsGame
    with HasKeyboardHandlerComponents {
  BackboardGameOverGame(this.score, this.character)
      : super(
          imagesFileNames: [
            components.Assets.images.score.points5k.keyName,
            components.Assets.images.score.points10k.keyName,
            components.Assets.images.score.points15k.keyName,
            components.Assets.images.score.points20k.keyName,
            components.Assets.images.score.points25k.keyName,
            components.Assets.images.score.points30k.keyName,
            components.Assets.images.score.points40k.keyName,
            components.Assets.images.score.points50k.keyName,
            components.Assets.images.score.points60k.keyName,
            components.Assets.images.score.points80k.keyName,
            components.Assets.images.score.points100k.keyName,
            components.Assets.images.score.points120k.keyName,
            components.Assets.images.score.points200k.keyName,
            components.Assets.images.score.points400k.keyName,
            components.Assets.images.score.points600k.keyName,
            components.Assets.images.score.points800k.keyName,
            components.Assets.images.score.points1m.keyName,
            components.Assets.images.score.points1m2.keyName,
            components.Assets.images.score.points2m.keyName,
            components.Assets.images.score.points3m.keyName,
            components.Assets.images.score.points4m.keyName,
            components.Assets.images.score.points5m.keyName,
            components.Assets.images.score.points6m.keyName,
            ...characterIconPaths.values.toList(),
          ],
        );

  static const description = '''
      Shows how the Backboard in game over mode is rendered.

      - Select a character to update the character icon.
  ''';

  static final characterIconPaths = <String, String>{
    'Dash': Assets.images.dash.leaderboardIcon.keyName,
    'Sparky': Assets.images.sparky.leaderboardIcon.keyName,
    'Android': Assets.images.android.leaderboardIcon.keyName,
    'Dino': Assets.images.dino.leaderboardIcon.keyName,
  };

  final int score;

  final String character;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera
      ..followVector2(Vector2.zero())
      ..zoom = 5;

    await add(
      components.Backboard.gameOver(
        position: Vector2(0, 20),
        score: score,
        characterIconPath: characterIconPaths[character]!,
        onSubmit: (initials) {
          add(
            components.ScoreComponent(
              points: components.Points.values
                  .firstWhere((element) => element.value == score),
              position: Vector2(0, 50),
            ),
          );
        },
      ),
    );
  }
}
