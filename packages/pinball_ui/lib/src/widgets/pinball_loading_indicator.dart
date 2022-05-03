import 'package:flutter/material.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template pinball_loading_indicator}
/// Pixel-art loading indicator
/// {@endtemplate}
class PinballLoadingIndicator extends StatelessWidget {
  /// {@macro pinball_loading_indicator}
  const PinballLoadingIndicator({
    Key? key,
    required this.value,
  })  : assert(
          value >= 0.0 && value <= 1.0,
          'Progress must be between 0 and 1',
        ),
        super(key: key);

  /// Progress value
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InnerIndicator(value: value, widthFactor: 0.95),
        _InnerIndicator(value: value, widthFactor: 0.98),
        _InnerIndicator(value: value),
        _InnerIndicator(value: value),
        _InnerIndicator(value: value, widthFactor: 0.98),
        _InnerIndicator(value: value, widthFactor: 0.95)
      ],
    );
  }
}

class _InnerIndicator extends StatelessWidget {
  const _InnerIndicator({
    Key? key,
    required this.value,
    this.widthFactor = 1.0,
  }) : super(key: key);

  final double value;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Column(
        children: [
          LinearProgressIndicator(
            backgroundColor: PinballColors.loadingDarkBlue,
            color: PinballColors.loadingDarkRed,
            value: value,
          ),
          LinearProgressIndicator(
            backgroundColor: PinballColors.loadingLightBlue,
            color: PinballColors.loadingLightRed,
            value: value,
          ),
        ],
      ),
    );
  }
}
