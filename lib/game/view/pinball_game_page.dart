// ignore_for_file: public_member_api_docs

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_theme/pinball_theme.dart';

class PinballGamePage extends StatelessWidget {
  const PinballGamePage({Key? key, required this.theme}) : super(key: key);

  final PinballTheme theme;

  static Route route({required PinballTheme theme}) {
    return MaterialPageRoute<void>(
      builder: (_) {
        return BlocProvider(
          create: (_) => GameBloc(),
          child: PinballGamePage(theme: theme),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PinballGameView(theme: theme);
  }
}

class PinballGameView extends StatefulWidget {
  const PinballGameView({Key? key, required this.theme}) : super(key: key);

  final PinballTheme theme;

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
    _game = PinballGame(theme: widget.theme)..preLoadAssets();
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
