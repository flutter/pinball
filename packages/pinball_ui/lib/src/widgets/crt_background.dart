import 'package:flutter/material.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template crt_background}
/// [BoxDecoration] that provides a CRT-like background effect.
/// {@endtemplate}
class CrtBackground extends BoxDecoration {
  /// {@macro crt_background}
  const CrtBackground()
      : super(
          gradient: const LinearGradient(
            begin: Alignment(1, 0.015),
            stops: [0.0, 0.5, 0.5, 1],
            colors: [
              PinballColors.darkBlue,
              PinballColors.darkBlue,
              PinballColors.crtBackground,
              PinballColors.crtBackground,
            ],
            tileMode: TileMode.repeated,
          ),
        );
}
