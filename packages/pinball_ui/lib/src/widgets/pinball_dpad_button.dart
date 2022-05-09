import 'package:flutter/material.dart';
import 'package:pinball_ui/gen/gen.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// Enum with all possible directions of a [PinballDpadButton].
enum PinballDpadDirection {
  /// Up
  up,

  /// Down
  down,

  /// Left
  left,

  /// Right
  right,
}

extension _PinballDpadDirectionX on PinballDpadDirection {
  String toAsset() {
    switch (this) {
      case PinballDpadDirection.up:
        return Assets.images.button.dpadUp.keyName;
      case PinballDpadDirection.down:
        return Assets.images.button.dpadDown.keyName;
      case PinballDpadDirection.left:
        return Assets.images.button.dpadLeft.keyName;
      case PinballDpadDirection.right:
        return Assets.images.button.dpadRight.keyName;
    }
  }
}

/// {@template pinball_dpad_button}
/// Widget that renders a Dpad button with a given direction.
/// {@endtemplate}
class PinballDpadButton extends StatelessWidget {
  /// {@macro pinball_dpad_button}
  const PinballDpadButton({
    Key? key,
    required this.direction,
    required this.onTap,
  }) : super(key: key);

  /// Which [PinballDpadDirection] this button is.
  final PinballDpadDirection direction;

  /// The function executed when the button is pressed.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PinballColors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          direction.toAsset(),
          width: 60,
          height: 60,
        ),
      ),
    );
  }
}
