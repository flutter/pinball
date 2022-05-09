import 'package:flutter/material.dart';
import 'package:pinball_ui/gen/gen.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template pinball_button}
/// Pinball-themed button with pixel art.
/// {@endtemplate}
class PinballButton extends StatelessWidget {
  /// {@macro pinball_button}
  const PinballButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  /// Text of the button.
  final String text;

  /// Tap callback.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PinballColors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.images.button.pinballButton.keyName),
          ),
        ),
        child: Center(
          child: InkWell(
            onTap: onTap,
            highlightColor: PinballColors.transparent,
            splashColor: PinballColors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: PinballColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
