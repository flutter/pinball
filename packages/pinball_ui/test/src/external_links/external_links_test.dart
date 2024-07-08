import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _MockLaunchOptions extends Mock implements LaunchOptions {}

void main() {
  late UrlLauncherPlatform urlLauncher;

  setUp(() {
    urlLauncher = _MockUrlLauncher();
    UrlLauncherPlatform.instance = urlLauncher;
  });

  setUpAll(() {
    registerFallbackValue(_MockLaunchOptions());
  });

  group('openLink', () {
    test('launches the link', () async {
      when(
        () => urlLauncher.canLaunch(any()),
      ).thenAnswer(
        (_) async => true,
      );
      when(
        () => urlLauncher.launchUrl(any(), any()),
      ).thenAnswer(
        (_) async => Future.value(true),
      );
      await openLink('uri');
      verify(
        () => urlLauncher.launchUrl(
          any(),
          any(),
        ),
      );
    });

    test('executes the onError callback when it cannot launch', () async {
      var wasCalled = false;
      when(
        () => urlLauncher.canLaunch(any()),
      ).thenAnswer(
        (_) async => false,
      );
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
      ).thenAnswer(
        (_) async => true,
      );
      await openLink(
        'url',
        onError: () {
          wasCalled = true;
        },
      );
      await expectLater(wasCalled, isTrue);
    });
  });
}
