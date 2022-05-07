import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';

final _bodyTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.8,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
    fontWeight: FontWeight.w400,
  ),
);

/// {@template initials_submission_failure_display}
/// [Backbox] display for when a failure occurs during initials submission.
/// {@endtemplate}
class InitialsSubmissionFailureDisplay extends Component {
  /// {@macro initials_submission_failure_display}
  InitialsSubmissionFailureDisplay({
    required this.onDismissed,
  });

  final VoidCallback onDismissed;

  @override
  Future<void> onLoad() async {
    final l10n = readProvider<AppLocalizations>();

    await addAll([
      ErrorComponent.bold(
        label: l10n.initialsErrorTitle,
        position: Vector2(0, -20),
      ),
      TextComponent(
        text: l10n.initialsErrorMessage,
        anchor: Anchor.center,
        position: Vector2(0, -12),
        textRenderer: _bodyTextPaint,
      ),
      TimerComponent(period: 4, onTick: onDismissed),
    ]);
  }
}
