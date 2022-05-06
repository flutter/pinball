import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template mobile_controls}
/// Widget with the controls used to enable the user initials input on mobile.
/// {@endtemplate}
class MobileControls extends StatelessWidget {
  /// {@macro mobile_controls}
  const MobileControls({Key? key,
    required this.onTapUp,
    required this.onTapDown,
    required this.onTapLeft,
    required this.onTapRight,
    required this.onTapEnter,
  }) : super(key: key);

  /// Called when dpad up is pressed
  final VoidCallback onTapUp;

  /// Called when dpad down is pressed
  final VoidCallback onTapDown;

  /// Called when dpad left is pressed
  final VoidCallback onTapLeft;

  /// Called when dpad right is pressed
  final VoidCallback onTapRight;

  /// Called when enter is pressed
  final VoidCallback onTapEnter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MobileDpad(
            onTapUp: onTapUp,
            onTapDown: onTapUp,
            onTapLeft: onTapLeft,
            onTapRight: onTapRight,
        ),
        PinballButton(
          text: 'Enter', // TODO l10n
          onTap: onTapEnter,
        ),
      ],
    );
  }
}
