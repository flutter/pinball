import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';

final _bodyTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 3,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

/// {@template loading_display}
/// Display used to show the loading animation.
/// {@endtemplate}
class LoadingDisplay extends TextComponent {
  /// {@template loading_display}
  LoadingDisplay();

  late final String _label;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = Vector2(0, -10);
    anchor = Anchor.center;
    text = _label = readProvider<AppLocalizations>().loading;
    textRenderer = _bodyTextPaint;

    await add(
      TimerComponent(
        period: 1,
        repeat: true,
        onTick: () {
          final index = text.indexOf('.');
          if (index != -1 && text.substring(index).length == 3) {
            text = _label;
          } else {
            text = '$text.';
          }
        },
      ),
    );
  }
}
