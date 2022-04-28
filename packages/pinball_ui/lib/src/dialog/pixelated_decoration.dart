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

    return Material(
      borderRadius: radius,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(Assets.images.dialog.background.keyName),
            ),
          ),
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
      ),
    );
  }
}
