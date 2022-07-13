import 'dart:async';

import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class DashBumperBGame extends BallGame {
  DashBumperBGame()
      : super(
          imagesFileNames: [
            Assets.images.dash.bumper.b.active.keyName,
            Assets.images.dash.bumper.b.inactive.keyName,
          ],
        );

  static const description = '''
    Shows how the "b" DashBumper is rendered.

    - Activate the "trace" parameter to overlay the body.
''';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.followVector2(Vector2.zero());
    await add(
      FlameBlocProvider<DashBumpersCubit, DashBumpersState>(
        create: DashBumpersCubit.new,
        children: [
          DashBumper.b()..priority = 1,
        ],
      ),
    );
    await traceAllBodies();
  }
}
