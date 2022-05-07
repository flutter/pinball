import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// Inflates [MoreInformationDialog] using [showDialog].
Future<void> showMoreInformationDialog(BuildContext context) {
  final gameWidgetWidth = MediaQuery.of(context).size.height * 9 / 16;

  return showDialog<void>(
    context: context,
    barrierColor: PinballColors.transparent,
    barrierDismissible: true,
    builder: (_) {
      return Center(
        child: SizedBox(
          height: gameWidgetWidth * 0.87,
          width: gameWidgetWidth,
          child: const MoreInformationDialog(),
        ),
      );
    },
  );
}

/// {@template more_information_dialog}
/// Dialog used to show informational links
/// {@endtemplate}
class MoreInformationDialog extends StatelessWidget {
  /// {@macro more_information_dialog}
  const MoreInformationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PinballColors.transparent,
      child: _LinkBoxDecoration(
        child: Column(
          children: const [
            SizedBox(height: 16),
            _LinkBoxHeader(),
            Expanded(
              child: _LinkBoxBody(),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkBoxHeader extends StatelessWidget {
  const _LinkBoxHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Text(
          l10n.linkBoxTitle,
          style: Theme.of(context).textTheme.headline3!.copyWith(
                color: PinballColors.blue,
                fontWeight: FontWeight.bold,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        const SizedBox(
          width: 200,
          child: Divider(color: PinballColors.white, thickness: 2),
        ),
      ],
    );
  }
}

class _LinkBoxDecoration extends StatelessWidget {
  const _LinkBoxDecoration({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const CrtBackground().copyWith(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: PinballColors.white,
          width: 5,
        ),
      ),
      child: child,
    );
  }
}

class _LinkBoxBody extends StatelessWidget {
  const _LinkBoxBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const _MadeWithFlutterAndFirebase(),
        _TextLink(
          text: l10n.linkBoxOpenSourceCode,
          link: _MoreInformationUrl.openSourceCode,
        ),
        _TextLink(
          text: l10n.linkBoxGoogleIOText,
          link: _MoreInformationUrl.googleIOEvent,
        ),
        _TextLink(
          text: l10n.linkBoxFlutterGames,
          link: _MoreInformationUrl.flutterGamesWebsite,
        ),
        _TextLink(
          text: l10n.linkBoxHowItsMade,
          link: _MoreInformationUrl.howItsMadeArticle,
        ),
        _TextLink(
          text: l10n.linkBoxTermsOfService,
          link: _MoreInformationUrl.termsOfService,
        ),
        _TextLink(
          text: l10n.linkBoxPrivacyPolicy,
          link: _MoreInformationUrl.privacyPolicy,
        ),
      ],
    );
  }
}

class _TextLink extends StatelessWidget {
  const _TextLink({
    Key? key,
    required this.text,
    required this.link,
  }) : super(key: key);

  final String text;
  final String link;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => openLink(link),
      child: Text(
        text,
        style: theme.textTheme.headline5!.copyWith(
          color: PinballColors.white,
        ),
        overflow: TextOverflow.ellipsis,
      ),
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
        text: l10n.linkBoxMadeWithText,
        style: theme.textTheme.headline5!.copyWith(color: PinballColors.white),
        children: <TextSpan>[
          TextSpan(
            text: l10n.linkBoxFlutterLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(_MoreInformationUrl.flutterWebsite),
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: ' & '),
          TextSpan(
            text: l10n.linkBoxFirebaseLinkText,
            recognizer: TapGestureRecognizer()
              ..onTap = () => openLink(_MoreInformationUrl.firebaseWebsite),
            style: theme.textTheme.headline5!.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

abstract class _MoreInformationUrl {
  static const flutterWebsite = 'https://flutter.dev';
  static const firebaseWebsite = 'https://firebase.google.com';
  static const openSourceCode = 'https://github.com/VGVentures/pinball';
  static const googleIOEvent = 'https://events.google.com/io/';
  static const flutterGamesWebsite = 'http://flutter.dev/games';
  static const howItsMadeArticle =
      'https://medium.com/flutter/i-o-pinball-powered-by-flutter-and-firebase-d22423f3f5d';
  static const termsOfService = 'https://policies.google.com/terms';
  static const privacyPolicy = 'https://policies.google.com/privacy';
}
