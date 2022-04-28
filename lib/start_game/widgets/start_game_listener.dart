// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball/theme/theme.dart';

class StartGameListener extends StatelessWidget {
  const StartGameListener({
    Key? key,
    required Widget child,
    required PinballGame game,
  })  : _child = child,
        _game = game,
        super(key: key);

  final Widget _child;
  final PinballGame _game;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartGameBloc, StartGameState>(
      listener: (context, state) {
        switch (state.status) {
          case StartGameStatus.selectCharacter:
            _onSelectCharacter(context);
            break;
          case StartGameStatus.howToPlay:
            _onHowToPlay(context);
            break;
          case StartGameStatus.play:
            _game.gameFlowController.start();
            break;
          case StartGameStatus.initial:
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
}

Future<void> _onHowToPlay(BuildContext context) async {
  _showPinballDialog(
    context: context,
    child: HowToPlayDialog(
      onDismissCallback: () {
        // We need to add a delay between closing the dialog and starting the
        // game.
        Future.delayed(
          kThemeAnimationDuration,
          () => context.read<StartGameBloc>().add(const HowToPlayFinished()),
        );
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
    barrierColor: AppColors.transparent,
    barrierDismissible: barrierDismissible,
    builder: (_) {
      return Center(
        child: SizedBox(
          height: gameWidgetWidth,
          width: gameWidgetWidth,
          child: child,
        ),
      );
    },
  );
}
