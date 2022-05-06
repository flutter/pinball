import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';

/// Handles removing a [Ball] from the game.
class DrainingBehavior extends ContactBehavior<Drain> with HasGameRef {
  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    if (other is! Ball) return;

    other.removeFromParent();
    final ballsLeft = gameRef.descendants().whereType<Ball>().length;
    if (ballsLeft - 1 == 0) {
      ancestors()
          .whereType<FlameBlocProvider<GameBloc, GameState>>()
          .first
          .bloc
          .add(const RoundLost());
    }
  }
}
