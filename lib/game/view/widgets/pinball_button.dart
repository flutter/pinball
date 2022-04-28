import 'package:flutter/material.dart';
import 'package:pinball/gen/gen.dart';

// TODO(arturplaczek): move PinballButton to pinball_ui

/// {@template pinball_button}
/// Pinball button with onPressed [VoidCallback] and child [Widget].
/// {@endtemplate}
class PinballButton extends StatelessWidget {
  /// {@macro pinball_button}
  const PinballButton({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
  })  : _child = child,
        _onPressed = onPressed,
        super(key: key);

  final Widget _child;
  final VoidCallback? _onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onPressed,
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
            child: _child,
          ),
        ),
      ),
    );
  }
}
