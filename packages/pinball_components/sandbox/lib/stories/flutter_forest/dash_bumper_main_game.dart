import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class DashBumperMainGame extends BallGame {
  DashBumperMainGame()
      : super(
          imagesFileNames: [
            Assets.images.dash.bumper.main.active.keyName,
            Assets.images.dash.bumper.main.inactive.keyName,
          ],
        );

  static const description = '''
    Shows how the "main" DashBumper is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.follow(PositionComponent(position: Vector2.zero()));
    await add(
      FlameBlocProvider<DashBumpersCubit, DashBumpersState>(
        create: DashBumpersCubit.new,
        children: [
          DashBumper.main()..priority = 1,
        ],
      ),
    );
    await traceAllBodies();
  }
}
