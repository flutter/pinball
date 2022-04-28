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
            _handleHowToPlay(context);
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

  void _onSelectCharacter(
    BuildContext context,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) {
        // TODO(arturplaczek): remove that when PR with PinballLayout will be
        // merged
        final height = MediaQuery.of(context).size.height * 0.5;

        return Center(
          child: SizedBox(
            height: height,
            width: height * 1.2,
            child: const CharacterSelectionDialog(),
          ),
        );
      },
      barrierDismissible: false,
    );
  }
}

Future<void> _handleHowToPlay(
  BuildContext context,
) async {
  final startGameBloc = context.read<StartGameBloc>();

  await showDialog<void>(
    context: context,
    barrierColor: AppColors.transparent,
    builder: (_) {
      return Center(
        child: HowToPlayDialog(
          onDismissCallback: () {
            startGameBloc.add(const HowToPlayFinished());
          },
        ),
      );
    },
  );
}
