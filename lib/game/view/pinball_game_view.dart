import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';

class PinballGameView extends StatelessWidget {
  const PinballGameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state.isGameOver) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return const Dialog(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Center(
                    child: Text('Game Over'),
                  ),
                ),
              );
            },
          );
        }
      },
      child: GameWidget<PinballGame>(game: PinballGame()),
    );
  }
}
