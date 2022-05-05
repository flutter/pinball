import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_ui/pinball_ui.dart';

final _bodyTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 3,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

/// {@template initials_submission_success_display}
/// [Backbox] display for initials successfully submitted.
/// {@endtemplate}
class InitialsSubmissionSuccessDisplay extends TextComponent
    with HasGameRef<PinballGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = Vector2(0, -10);
    anchor = Anchor.center;
    text = 'Success!';
    textRenderer = _bodyTextPaint;
  }
}
