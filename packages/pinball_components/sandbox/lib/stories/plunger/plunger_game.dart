import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/common/common.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class PlungerGame extends BallGame
    with HasKeyboardHandlerComponents, Traceable {
  PlungerGame()
      : super(
          imagesFileNames: [
            Assets.images.plunger.plunger.keyName,
          ],
        );

  static const description = '''
    Shows how Plunger is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap anywhere on the screen to spawn a ball into the game.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final center = screenToWorld(camera.viewport.canvasSize! / 2);
    final plunger = Plunger()
      ..initialPosition = Vector2(center.x - 8.8, center.y);
    await add(
      FlameBlocProvider<PlungerCubit, PlungerState>(
        create: PlungerCubit.new,
        children: [plunger],
      ),
    );
    await plunger.add(PlungerKeyControllingBehavior());

    await traceAllBodies();
  }
}
