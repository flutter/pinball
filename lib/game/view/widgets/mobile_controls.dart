import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template mobile_controls}
/// Widget with the controls used to enable the user initials input on mobile.
/// {@endtemplate}
class MobileControls extends StatelessWidget {
  /// {@macro mobile_controls}
  const MobileControls({
    Key? key,
    required this.game,
  }) : super(key: key);

  /// Game instance
  final PinballGame game;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MobileDpad(
          onTapUp: () => game.triggerVirtualKeyUp(LogicalKeyboardKey.arrowUp),
          onTapDown: () => game.triggerVirtualKeyUp(
            LogicalKeyboardKey.arrowDown,
          ),
          onTapLeft: () => game.triggerVirtualKeyUp(
            LogicalKeyboardKey.arrowLeft,
          ),
          onTapRight: () => game.triggerVirtualKeyUp(
            LogicalKeyboardKey.arrowRight,
          ),
        ),
        PinballButton(
          text: l10n.enter,
          onTap: () => game.triggerVirtualKeyUp(LogicalKeyboardKey.enter),
        ),
      ],
    );
  }
}
