import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';

class PinballGame extends Forge2DGame with FlameBloc {
  @override
  Future<void> onLoad() async {
    addContactCallback(BallScorePointsCallback());
  }
}
