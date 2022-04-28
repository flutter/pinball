import 'package:flutter/material.dart';
import 'package:pinball/game/pinball_game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';

/// {@template play_button_overlay}
/// [Widget] that renders the button responsible to starting the game
/// {@endtemplate}
class PlayButtonOverlay extends StatelessWidget {
  /// {@macro play_button_overlay}
  const PlayButtonOverlay({
    Key? key,
    required PinballGame game,
  })  : _game = game,
        super(key: key);

  final PinballGame _game;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: ElevatedButton(
        onPressed: () {
          _game.gameFlowController.start();
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              final height = MediaQuery.of(context).size.height * 0.5;

              return Center(
                child: SizedBox(
                  height: height,
                  width: height * 1.4,
                  child: const CharacterSelectionDialog(),
                ),
              );
            },
          );
        },
        child: Text(l10n.play),
      ),
    );
  }
}
