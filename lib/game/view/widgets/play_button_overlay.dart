import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template play_button_overlay}
/// [Widget] that renders the button responsible to starting the game
/// {@endtemplate}
class PlayButtonOverlay extends StatelessWidget {
  /// {@macro play_button_overlay}
  const PlayButtonOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PinballButton(
      text: l10n.play,
      onTap: () {
        context.read<StartGameBloc>().add(const PlayTapped());
      },
    );
  }
}
