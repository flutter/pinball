import 'package:flutter/material.dart';
import 'package:pinball/gen/gen.dart';

/// {@template pinball_button}
/// Pinball button with onPressed [VoidCallback] and child [Widget].
/// {@endtemplate}
class PinballButton extends StatelessWidget {
  /// {@macro pinball_button}
  const PinballButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  /// Child displayed on button.
  final Widget child;

  /// On pressed callback used for user integration.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.images.selectCharacter.pinballButton.keyName,
            ),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
