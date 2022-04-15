// ignore_for_file: public_member_api_docs

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/start_game/bloc/start_game_bloc.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_audio/pinball_audio.dart';

class PinballGamePage extends StatelessWidget {
  const PinballGamePage({
    Key? key,
    this.isDebugMode = kDebugMode,
  }) : super(key: key);

  final bool isDebugMode;

  static Route route({
    bool isDebugMode = kDebugMode,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) {
        return PinballGamePage(
          isDebugMode: isDebugMode,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeCubit>().state.theme;
    final audio = context.read<PinballAudio>();
    final pinballAudio = context.read<PinballAudio>();

    final game = isDebugMode
        ? DebugPinballGame(theme: theme, audio: audio)
        : PinballGame(theme: theme, audio: audio);

    final loadables = [
      ...game.preLoadAssets(),
      pinballAudio.load(),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StartGameBloc(game: game)),
        BlocProvider(create: (_) => GameBloc()),
        BlocProvider(
          create: (_) => AssetsManagerCubit(loadables)..load(),
        ),
      ],
      child: PinballGameView(
        game: game,
      ),
    );
  }
}

class PinballGameView extends StatelessWidget {
  const PinballGameView({
    Key? key,
    required this.game,
  }) : super(key: key);

  final PinballGame game;

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select(
      (AssetsManagerCubit bloc) => bloc.state.progress != 1,
    );

    return Scaffold(
      backgroundColor: Colors.blue,
      body: isLoading
          ? _PinballGameLoadingView()
          : PinballGameBody(
              game: game,
            ),
    );
  }
}

class _PinballGameLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loadingProgress = context.select(
      (AssetsManagerCubit bloc) => bloc.state.progress,
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: LinearProgressIndicator(
          color: Colors.white,
          value: loadingProgress,
        ),
      ),
    );
  }
}

@visibleForTesting
class PinballGameBody extends StatelessWidget {
  const PinballGameBody({
    Key? key,
    required this.game,
  }) : super(key: key);

  final PinballGame game;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GameWidget<PinballGame>(
            game: game,
            initialActiveOverlays: const [PinballGame.playButtonOverlay],
            overlayBuilderMap: {
              PinballGame.playButtonOverlay: (context, game) {
                return Positioned(
                  bottom: 20,
                  right: 0,
                  left: 0,
                  child: PlayButtonOverlay(game: game),
                );
              },
            },
          ),
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
