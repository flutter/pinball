// ignore_for_file: public_member_api_docs

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/assets_manager/assets_manager.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/gen.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/more_information/more_information.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_ui/pinball_ui.dart';

class PinballGamePage extends StatelessWidget {
  const PinballGamePage({
    Key? key,
    this.isDebugMode = kDebugMode,
  }) : super(key: key);

  final bool isDebugMode;

  static Route route({bool isDebugMode = kDebugMode}) {
    return MaterialPageRoute<void>(
      builder: (_) => PinballGamePage(isDebugMode: isDebugMode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterThemeBloc = context.read<CharacterThemeCubit>();
    final player = context.read<PinballPlayer>();
    final leaderboardRepository = context.read<LeaderboardRepository>();
    final gameBloc = context.read<GameBloc>();
    final game = isDebugMode
        ? DebugPinballGame(
            characterThemeBloc: characterThemeBloc,
            player: player,
            leaderboardRepository: leaderboardRepository,
            l10n: context.l10n,
            gameBloc: gameBloc,
          )
        : PinballGame(
            characterThemeBloc: characterThemeBloc,
            player: player,
            leaderboardRepository: leaderboardRepository,
            l10n: context.l10n,
            gameBloc: gameBloc,
          );

    final loadables = [
      ...game.preLoadAssets(),
      ...player.load(),
      ...BonusAnimation.loadAssets(),
      ...SelectedCharacter.loadAssets(),
    ];

    return BlocProvider(
      create: (_) => AssetsManagerCubit(loadables)..load(),
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
    return Container(
      decoration: const CrtBackground(),
      child: Scaffold(
        backgroundColor: PinballColors.transparent,
        body: isLoading
            ? const AssetsLoadingPage()
            : PinballGameLoadedView(game: game),
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
    return StartGameListener(
      child: Stack(
        children: [
          Positioned.fill(
            child: MouseRegion(
              onHover: (_) {
                if (!game.focusNode.hasFocus) {
                  game.focusNode.requestFocus();
                }
              },
              child: GameWidget<PinballGame>(
                game: game,
                focusNode: game.focusNode,
                initialActiveOverlays: const [PinballGame.playButtonOverlay],
                overlayBuilderMap: {
                  PinballGame.playButtonOverlay: (context, game) {
                    return const Positioned(
                      bottom: 20,
                      right: 0,
                      left: 0,
                      child: PlayButtonOverlay(),
                    );
                  },
                },
              ),
            ),
          ),
          const _PositionedGameHud(),
          const _PositionedInfoIcon(),
        ],
      ),
    );
  }
}

class _PositionedGameHud extends StatelessWidget {
  const _PositionedGameHud({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select(
      (StartGameBloc bloc) => bloc.state.status == StartGameStatus.play,
    );
    final isGameOver = context.select(
      (GameBloc bloc) => bloc.state.status.isGameOver,
    );

    final gameWidgetWidth = MediaQuery.of(context).size.height * 9 / 16;
    final screenWidth = MediaQuery.of(context).size.width;
    final leftMargin = (screenWidth / 2) - (gameWidgetWidth / 1.8);
    final clampedMargin = leftMargin > 0 ? leftMargin : 0.0;

    return Positioned(
      top: 0,
      left: clampedMargin,
      child: Visibility(
        visible: isPlaying && !isGameOver,
        child: const GameHud(),
      ),
    );
  }
}

class _PositionedInfoIcon extends StatelessWidget {
  const _PositionedInfoIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return Visibility(
            visible: state.status.isGameOver,
            child: IconButton(
              iconSize: 50,
              icon: Assets.images.linkBox.infoIcon.image(),
              onPressed: () => showMoreInformationDialog(context),
            ),
          );
        },
      ),
    );
  }
}
