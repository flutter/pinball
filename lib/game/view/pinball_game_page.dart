// ignore_for_file: public_member_api_docs

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_theme/pinball_theme.dart';

class PinballGamePage extends StatelessWidget {
  const PinballGamePage({
    Key? key,
    required this.theme,
    required this.game,
  }) : super(key: key);

  final PinballTheme theme;
  final PinballGame game;

  static Route route({
    required PinballTheme theme,
    bool isDebugMode = kDebugMode,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) {
        final audio = context.read<PinballAudio>();

        final game = isDebugMode
            ? DebugPinballGame(theme: theme, audio: audio)
            : PinballGame(theme: theme, audio: audio);

        final pinballAudio = context.read<PinballAudio>();
        final loadables = [
          ...game.preLoadAssets(),
          pinballAudio.load(),
        ];

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => GameBloc()),
            BlocProvider(
              create: (_) => AssetsManagerCubit(loadables)..load(),
            ),
          ],
          child: PinballGamePage(theme: theme, game: game),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PinballGameView(theme: theme, game: game);
  }
}

class PinballGameView extends StatelessWidget {
  const PinballGameView({
    Key? key,
    required this.theme,
    required this.game,
  }) : super(key: key);

  final PinballTheme theme;
  final PinballGame game;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listenWhen: (previous, current) =>
          previous.isGameOver != current.isGameOver,
      listener: (context, state) {
        if (state.isGameOver) {
          showDialog<void>(
            context: context,
            builder: (_) {
              return GameOverDialog(
                score: state.score,
                theme: theme.characterTheme,
              );
            },
          );
        }
      },
      child: _GameView(game: game),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView({
    Key? key,
    required PinballGame game,
  })  : _game = game,
        super(key: key);

  final PinballGame _game;

  @override
  Widget build(BuildContext context) {
    final loadingProgress = context.watch<AssetsManagerCubit>().state.progress;

    if (loadingProgress != 1) {
      return Scaffold(
        body: Center(
          child: Text(
            loadingProgress.toString(),
          ),
        ),
      );
    }

    return Stack(
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
    );
  }
}
