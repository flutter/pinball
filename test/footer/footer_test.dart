import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/footer/footer.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../helpers/helpers.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  group('Footer', () {
    late UrlLauncherPlatform urlLauncher;

    setUp(() async {
      urlLauncher = _MockUrlLauncher();
      UrlLauncherPlatform.instance = urlLauncher;
    });
    testWidgets('renders "Made with..." and "Google I/O"', (tester) async {
      await tester.pumpApp(const Footer());
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
          () => urlLauncher.launch(
            any(),
            useSafariVC: any(named: 'useSafariVC'),
            useWebView: any(named: 'useWebView'),
            enableJavaScript: any(named: 'enableJavaScript'),
            enableDomStorage: any(named: 'enableDomStorage'),
            universalLinksOnly: any(named: 'universalLinksOnly'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => true);
        await tester.pumpApp(const Footer());
        final flutterTextFinder = find.byWidgetPredicate(
          (widget) => widget is RichText && tapTextSpan(widget, 'Flutter'),
        );
        await tester.tap(flutterTextFinder);
        await tester.pumpAndSettle();
        verify(
          () => urlLauncher.launch(
            'https://flutter.dev',
            useSafariVC: any(named: 'useSafariVC'),
            useWebView: any(named: 'useWebView'),
            enableJavaScript: any(named: 'enableJavaScript'),
            enableDomStorage: any(named: 'enableDomStorage'),
            universalLinksOnly: any(named: 'universalLinksOnly'),
            headers: any(named: 'headers'),
          ),
        );
      },
    );

    testWidgets(
      'tapping on "Firebase" opens the firebase website',
      (tester) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
        when(
          () => urlLauncher.launch(
            any(),
            useSafariVC: any(named: 'useSafariVC'),
            useWebView: any(named: 'useWebView'),
            enableJavaScript: any(named: 'enableJavaScript'),
            enableDomStorage: any(named: 'enableDomStorage'),
            universalLinksOnly: any(named: 'universalLinksOnly'),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) async => true);
        await tester.pumpApp(const Footer());
        final firebaseTextFinder = find.byWidgetPredicate(
          (widget) => widget is RichText && tapTextSpan(widget, 'Firebase'),
        );
        await tester.tap(firebaseTextFinder);
        await tester.pumpAndSettle();
        verify(
          () => urlLauncher.launch(
            'https://firebase.google.com',
            useSafariVC: any(named: 'useSafariVC'),
            useWebView: any(named: 'useWebView'),
            enableJavaScript: any(named: 'enableJavaScript'),
            enableDomStorage: any(named: 'enableDomStorage'),
            universalLinksOnly: any(named: 'universalLinksOnly'),
            headers: any(named: 'headers'),
          ),
        );
      },
    );
  });
}
