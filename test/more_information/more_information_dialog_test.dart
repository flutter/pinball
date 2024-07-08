import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/more_information/more_information.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../helpers/helpers.dart';

bool _tapTextSpan(RichText richText, String text) {
  final isTapped = !richText.text.visitChildren(
    (visitor) => _findTextAndTap(visitor, text),
  );
  return isTapped;
}

bool _findTextAndTap(InlineSpan visitor, String text) {
  if (visitor is TextSpan && visitor.text == text) {
    (visitor.recognizer as TapGestureRecognizer?)?.onTap?.call();
    return false;
  }
  return true;
}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _MockLaunchOptions extends Mock implements LaunchOptions {}

void main() {
  group('MoreInformationDialog', () {
    late UrlLauncherPlatform urlLauncher;

    setUp(() async {
      urlLauncher = _MockUrlLauncher();
      UrlLauncherPlatform.instance = urlLauncher;
    });

    setUpAll(() {
      registerFallbackValue(_MockLaunchOptions());
    });

    group('showMoreInformationDialog', () {
      testWidgets('inflates the dialog', (tester) async {
        await tester.pumpApp(
          Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => showMoreInformationDialog(context),
                child: const Text('test'),
              );
            },
          ),
        );
        await tester.tap(find.text('test'));
        await tester.pump();
        expect(find.byType(MoreInformationDialog), findsOneWidget);
      });
    });

    testWidgets('renders "Made with..." and "Google I/O"', (tester) async {
      await tester.pumpApp(const MoreInformationDialog());
      expect(find.text('Google I/O'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText() == 'Made with Flutter & Firebase',
        ),
        findsOneWidget,
      );
    });

    testWidgets(
      'tapping on "Flutter" opens the flutter website',
      (tester) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
        when(
          () => urlLauncher.launchUrl(any(), any()),
        ).thenAnswer((_) async => Future.value(true));
        await tester.pumpApp(const MoreInformationDialog());
        final flutterTextFinder = find.byWidgetPredicate(
          (widget) => widget is RichText && _tapTextSpan(widget, 'Flutter'),
        );
        await tester.tap(flutterTextFinder);
        await tester.pumpAndSettle();
        verify(
          () => urlLauncher.launchUrl(
            'https://flutter.dev',
            any(),
          ),
        );
      },
    );

    testWidgets(
      'tapping on "Firebase" opens the firebase website',
      (tester) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
        when(
          () => urlLauncher.launchUrl(any(), any()),
        ).thenAnswer((_) async => Future.value(true));
        await tester.pumpApp(const MoreInformationDialog());
        final firebaseTextFinder = find.byWidgetPredicate(
          (widget) => widget is RichText && _tapTextSpan(widget, 'Firebase'),
        );
        await tester.tap(firebaseTextFinder);
        await tester.pumpAndSettle();
        verify(
          () => urlLauncher.launchUrl('https://firebase.google.com', any()),
        );
      },
    );

    <String, String>{
      'Open Source Code': 'https://github.com/flutter/pinball',
      'Google I/O': 'https://events.google.com/io/',
      'Flutter Games': 'http://flutter.dev/games',
      'How it’s made':
          'https://medium.com/flutter/i-o-pinball-powered-by-flutter-and-firebase-d22423f3f5d',
      'Terms of Service': 'https://policies.google.com/terms',
      'Privacy Policy': 'https://policies.google.com/privacy',
    }.forEach((text, link) {
      testWidgets(
        'tapping on "$text" opens the link - $link',
        (tester) async {
          when(() => urlLauncher.canLaunch(any()))
              .thenAnswer((_) async => true);
          when(
            () => urlLauncher.launchUrl(any(), any()),
          ).thenAnswer((_) async => Future.value(true));

          await tester.pumpApp(const MoreInformationDialog());
          await tester.tap(find.text(text));
          await tester.pumpAndSettle();

          verify(
            () => urlLauncher.launchUrl(
              link,
              any(),
            ),
          );
        },
      );
    });
  });
}
