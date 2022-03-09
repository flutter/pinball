import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';

/// {@template game_hud}
/// Overlay of a [PinballGame] that displays the current [GameState.score] and 
/// [GameState.balls].
/// {@endtemplate}
class GameHud extends StatelessWidget {
  /// {@macro game_hud}
  const GameHud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameBloc>().state;

    return Container(
      color: Colors.redAccent,
      width: 200,
      height: 100,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${state.score}',
            style: Theme.of(context).textTheme.headline3,
          ),
          Column(
            children: [
              for (var i = 0; i < state.balls; i++)
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.black,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
