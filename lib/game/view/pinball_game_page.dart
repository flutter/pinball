import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';

class PinballGamePage extends StatelessWidget {
  const PinballGamePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) {
        return BlocProvider(
          create: (_) => GameBloc(),
          child: const PinballGamePage(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const PinballGameView();
  }
}

class PinballGameView extends StatefulWidget {
  const PinballGameView({Key? key}) : super(key: key);

  @override
  State<PinballGameView> createState() => _PinballGameViewState();
}

class _PinballGameViewState extends State<PinballGameView> {
  late PinballGame _game;

  @override
  void initState() {
    super.initState();

    // TODO(erickzanardo): Revisit this when we start to have more assets
    // this could expose a Stream (maybe even a cubit?) so we could show the
    // the loading progress with some fancy widgets.
    _game = PinballGame()..preLoadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state.isGameOver) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return const GameOverDialog();
            },
          );
        }
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: GameWidget<PinballGame>(game: _game),
          ),
          const Positioned(
            top: 8,
            left: 8,
            child: GameHud(),
          ),
        ],
      ),
    );
  }
}
