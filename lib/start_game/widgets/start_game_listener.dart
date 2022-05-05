import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/how_to_play/how_to_play.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template start_game_listener}
/// Listener that manages the display of dialogs for [StartGameStatus].
///
/// It's responsible for starting the game after pressing play button
/// and playing a sound after the 'how to play' dialog.
/// {@endtemplate}
class StartGameListener extends StatelessWidget {
  /// {@macro start_game_listener}
  const StartGameListener({
    Key? key,
    required Widget child,
  })  : _child = child,
        super(key: key);

  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartGameBloc, StartGameState>(
      listener: (context, state) {
        switch (state.status) {
          case StartGameStatus.initial:
            break;
          case StartGameStatus.selectCharacter:
            _onSelectCharacter(context);
            context.read<GameBloc>().add(const GameStarted());
            break;
          case StartGameStatus.howToPlay:
            _onHowToPlay(context);
            break;
          case StartGameStatus.play:
            break;
        }
      },
      child: _child,
    );
  }

  void _onSelectCharacter(BuildContext context) {
    _showPinballDialog(
      context: context,
      child: const CharacterSelectionDialog(),
      barrierDismissible: false,
    );
  }

  void _onHowToPlay(BuildContext context) {
    _showPinballDialog(
      context: context,
      child: HowToPlayDialog(
        onDismissCallback: () {
          context.read<StartGameBloc>().add(const HowToPlayFinished());
        },
      ),
    );
  }

  void _showPinballDialog({
    required BuildContext context,
    required Widget child,
    bool barrierDismissible = true,
  }) {
    final gameWidgetWidth = MediaQuery.of(context).size.height * 9 / 16;

    showDialog<void>(
      context: context,
      barrierColor: PinballColors.transparent,
      barrierDismissible: barrierDismissible,
      builder: (_) {
        return Center(
          child: SizedBox(
            height: gameWidgetWidth * 0.87,
            width: gameWidgetWidth,
            child: child,
          ),
        );
      },
    );
  }
}
