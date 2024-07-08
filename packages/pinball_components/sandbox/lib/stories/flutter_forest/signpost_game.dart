import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:sandbox/stories/ball/basic_ball_game.dart';

class SignpostGame extends BallGame {
  SignpostGame()
      : super(
          imagesFileNames: [
            Assets.images.signpost.inactive.keyName,
            Assets.images.signpost.active1.keyName,
            Assets.images.signpost.active2.keyName,
            Assets.images.signpost.active3.keyName,
          ],
        );

  static const description = '''
    Shows how a Signpost is rendered.

    - Activate the "trace" parameter to overlay the body.
    - Tap to progress the sprite.
''';

  late final SignpostCubit _bloc;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _bloc = SignpostCubit();

    camera.follow(PositionComponent(position: Vector2.zero()));
    await add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<SignpostCubit, SignpostState>.value(
            value: _bloc,
          ),
          FlameBlocProvider<DashBumpersCubit, DashBumpersState>(
            create: DashBumpersCubit.new,
          ),
        ],
        children: [
          Signpost(),
        ],
      ),
    );
    await traceAllBodies();
  }

  @override
  void onTap() {
    super.onTap();
    _bloc.onProgressed();
  }
}
