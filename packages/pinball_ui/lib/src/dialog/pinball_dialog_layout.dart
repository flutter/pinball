import 'package:flutter/material.dart';
import 'package:pinball_ui/gen/gen.dart';

/// {@template pinball_dialog_layout}
/// Decoration for dialogs that display pixelated background and takes
/// two parameters:
/// - header [Widget]
/// - body [Widget]
///
/// Creates square, centered decoration the size of a game.
///
/// The header takes 20% of the area and the body remaining space.
/// {@endtemplate}
class PinballDialogLayout extends StatelessWidget {
  /// {@macro pinball_dialog_layout}
  const PinballDialogLayout({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final gameWidgetWidth = constraints.maxHeight * 9 / 16;

        return Center(
          child: SizedBox(
            height: gameWidgetWidth,
            width: gameWidgetWidth,
            child: _DialogDecoration(
              header: _header,
              body: _body,
            ),
          ),
        );
      },
    );
  }
}

class _DialogDecoration extends StatelessWidget {
  const _DialogDecoration({
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

    return DecoratedBox(
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
    );
  }
}
