import 'dart:async';

import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class AndroidSpaceshipGame extends BallGame {
  AndroidSpaceshipGame()
      : super(
          ballPriority: ZIndexes.ballOnSpaceship,
          ballLayer: Layer.spaceship,
          imagesFileNames: [
            Assets.images.android.spaceship.saucer.keyName,
            Assets.images.android.spaceship.animatronic.keyName,
            Assets.images.android.spaceship.lightBeam.keyName,
          ],
        );

  static const description = '''
    Shows how the AndroidSpaceship and AndroidAnimatronic are rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a Ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(
      FlameBlocProvider<AndroidSpaceshipCubit, AndroidSpaceshipState>(
        create: AndroidSpaceshipCubit.new,
        children: [
          AndroidSpaceship(position: Vector2.zero()),
          AndroidAnimatronic(),
        ],
      ),
    );

    await traceAllBodies();
  }
}
