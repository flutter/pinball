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
    int selectCharacterDelay = 1300,
  })  : _child = child,
        _game = game,
        _selectCharacterDelay = selectCharacterDelay,
        super(key: key);

  final Widget _child;
  final PinballGame _game;
  final int _selectCharacterDelay;

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartGameBloc, StartGameState>(
      listener: (context, state) {
        switch (state.status) {
          case StartGameStatus.initial:
            break;
          case StartGameStatus.selectCharacter:
            _game.gameFlowController.start();
            _onSelectCharacter(context);
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

  Future<void> _onSelectCharacter(BuildContext context) async {
    // We need to add a delay between starting the game and showing
    // the dialog.
    await Future<void>.delayed(
      Duration(milliseconds: _selectCharacterDelay),
    );
    _showPinballDialog(
      context: context,
      child: const CharacterSelectionDialog(),
      barrierDismissible: false,
    );
  }
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
    barrierColor: AppColors.transparent,
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
