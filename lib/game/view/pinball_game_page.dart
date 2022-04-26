// ignore_for_file: public_member_api_docs

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
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
    final characterTheme =
        context.read<CharacterThemeCubit>().state.characterTheme;
    final audio = context.read<PinballAudio>();
    final pinballAudio = context.read<PinballAudio>();

    final game = isDebugMode
        ? DebugPinballGame(characterTheme: characterTheme, audio: audio)
        : PinballGame(characterTheme: characterTheme, audio: audio);

    final loadables = [
      ...game.preLoadAssets(),
      pinballAudio.load(),
      ...BonusAnimation.loadAssets(),
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => StartGameBloc(game: game)),
        BlocProvider(create: (_) => GameBloc()),
        BlocProvider(
          create: (_) => AssetsManagerCubit(loadables)..load(),
        ),
      ],
      child: PinballGameView(game: game),
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
          ? const _PinballGameLoadingView()
          : PinballGameLoadedView(game: game),
    );
  }
}

class _PinballGameLoadingView extends StatelessWidget {
  const _PinballGameLoadingView({Key? key}) : super(key: key);

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
class PinballGameLoadedView extends StatelessWidget {
  const PinballGameLoadedView({
    Key? key,
    required this.game,
  }) : super(key: key);

  final PinballGame game;

  @override
  Widget build(BuildContext context) {
    final leftMargin = MediaQuery.of(context).size.width * 0.3;
    final isPlaying = context.select(
      (StartGameBloc bloc) => bloc.state.status == StartGameStatus.play,
    );

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
        Positioned(
          top: 16,
          left: leftMargin,
          child: Visibility(
            visible: isPlaying,
            child: const GameHud(),
          ),
        ),
      ],
    );
  }
}
