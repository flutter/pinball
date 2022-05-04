import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:pinball_components/pinball_components.dart' as components;
import 'package:pinball_theme/pinball_theme.dart';
import 'package:sandbox/common/common.dart';

class BackboardGameOverGame extends AssetsGame
    with HasKeyboardHandlerComponents {
  BackboardGameOverGame(this.score, this.character)
      : super(
          imagesFileNames: [
            components.Assets.images.score.fiveThousand.keyName,
            components.Assets.images.score.twentyThousand.keyName,
            components.Assets.images.score.twoHundredThousand.keyName,
            components.Assets.images.score.oneMillion.keyName,
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
              effectController: EffectController(duration: 1),
            ),
          );
        },
      ),
    );
  }
}
