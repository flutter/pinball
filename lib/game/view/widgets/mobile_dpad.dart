import 'package:flutter/material.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template mobile_dpad}
/// Widget that renders a 4 direction dpad.
/// {@endtemplate}
class MobileDpad extends StatelessWidget {
  /// {@template mobile_dpad}
  const MobileDpad({
    Key? key,
    required this.onTapUp,
    required this.onTapDown,
    required this.onTapLeft,
    required this.onTapRight,
  }) : super(key: key);

  static const _size = 180.0;

  /// Called when dpad up is pressed
  final VoidCallback onTapUp;

  /// Called when dpad down is pressed
  final VoidCallback onTapDown;

  /// Called when dpad left is pressed
  final VoidCallback onTapLeft;

  /// Called when dpad right is pressed
  final VoidCallback onTapRight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              PinballDpadButton(
                direction: PinballDpadDirection.up,
                onTap: onTapUp,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          Row(
            children: [
              PinballDpadButton(
                direction: PinballDpadDirection.left,
                onTap: onTapLeft,
              ),
              const Expanded(child: SizedBox()),
              PinballDpadButton(
                direction: PinballDpadDirection.right,
                onTap: onTapRight,
              ),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              PinballDpadButton(
                direction: PinballDpadDirection.down,
                onTap: onTapDown,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}
