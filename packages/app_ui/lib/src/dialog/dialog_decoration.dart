import 'package:app_ui/gen/gen.dart';
import 'package:flutter/material.dart';

/// {@template dialog_background}
/// A card with image background.
///
/// Requires the header [Widget] and body [Widget], which are displayed on the
/// card.
/// {@endtemplate}
class DialogDecoration extends StatelessWidget {
  /// {@macro dialog_background}
  const DialogDecoration({
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
    const boardWidth = 5.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final gameWidgetWidth = constraints.maxHeight * 9 / 16;

        return Center(
          child: SizedBox(
            height: gameWidgetWidth,
            width: gameWidgetWidth,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                border: Border.all(
                  color: Colors.white,
                  width: boardWidth,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    Assets.images.dialog.background.keyName,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(boardWidth - 1),
                child: ClipRRect(
                  borderRadius: radius,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(child: _header),
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
          ),
        );
      },
    );
  }
}
