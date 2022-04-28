import 'package:flutter/material.dart';
import 'package:pinball_ui/gen/gen.dart';

/// {@template pixelated_decoration}
/// Widget with pixelated background and layout defined for dialog displays.
/// {@endtemplate}
class PixelatedDecoration extends StatelessWidget {
  /// {@macro pixelated_decoration}
  const PixelatedDecoration({
    Key? key,
    required Widget header,
    required Widget body,
  })  : _header = header,
        _body = body,
        super(key: key);

  final Widget _header;
  final Widget _body;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(12));
    const borderWidth = 5.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(Assets.images.dialog.background.keyName),
        ),
        borderRadius: radius,
        border: Border.all(
          color: Colors.white,
          width: borderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(borderWidth),
        child: ClipRRect(
          borderRadius: radius,
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: _header,
                ),
              ),
              Expanded(
                flex: 4,
                child: _body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
