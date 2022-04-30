import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template footer}
/// Footer widget with links to the main tech stack.
/// {@endtemplate}
class Footer extends StatelessWidget {
  /// {@macro footer}
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          _MadeWithFlutterAndFirebase(),
          _GoogleIO(),
        ],
      ),
    );
  }
}

class _GoogleIO extends StatelessWidget {
  const _GoogleIO({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Text(
      l10n.footerGoogleIOText,
      style: theme.textTheme.bodyText1!.copyWith(color: AppColors.white),
    );
  }
}

class _MadeWithFlutterAndFirebase extends StatelessWidget {
  const _MadeWithFlutterAndFirebase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: l10n.footerMadeWithText,
        style: theme.textTheme.bodyText1!.copyWith(color: AppColors.white),
        children: <TextSpan>[
          TextSpan(
            text: l10n.footerFlutterLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink('https://flutter.dev'),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: ' & '),
          TextSpan(
            text: l10n.footerFirebaseLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink('https://firebase.google.com'),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
