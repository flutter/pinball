import 'package:flutter/material.dart';
import 'package:pinball/game/pinball_game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';

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
            builder: (_) {
              final width = MediaQuery.of(context).size.width * 0.9;
              final height = MediaQuery.of(context).size.height * 0.9;

              return Center(
                child: SizedBox(
                  height: height,
                  width: width,
                  child: const CharacterSelectionPage(),
                ),
              );
            },
            barrierDismissible: false,
          );
        },
        child: Text(l10n.play),
      ),
    );
  }
}
