// ignore_for_file: cascade_invocations

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/bloc/game_bloc.dart';
import 'package:pinball/game/components/backbox/displays/game_over_info_display.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_repository/share_repository.dart';

class _TestGame extends Forge2DGame with HasTappables {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    images.prefix = '';
    await images.loadAll(
      [
        Assets.images.backbox.displayTitleDecoration.keyName,
      ],
    );
  }

  Future<void> pump(GameOverInfoDisplay component) {
    return ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [
          FlameProvider.value(
            _MockAppLocalizations(),
            children: [component],
          ),
        ],
      ),
    );
  }
}

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get shareYourScore => '';

  @override
  String get andChallengeYourFriends => '';

  @override
  String get share => '';

  @override
  String get gotoIO => '';

  @override
  String get learnMore => '';

  @override
  String get firebaseOr => '';

  @override
  String get openSourceCode => '';
}

class _MockTapDownInfo extends Mock implements TapDownInfo {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  late UrlLauncherPlatform urlLauncher;

  setUp(() async {
    urlLauncher = _MockUrlLauncher();
    UrlLauncherPlatform.instance = urlLauncher;
  });

  group('InfoDisplay', () {
    flameTester.test(
      'loads correctly',
      (game) async {
        final component = GameOverInfoDisplay();
        await game.pump(component);
        expect(game.descendants(), contains(component));
      },
    );

    flameTester.test(
      'calls onShare when Share link is tapped',
      (game) async {
        var tapped = false;

        final tapDownInfo = _MockTapDownInfo();
        final component = GameOverInfoDisplay(
          onShare: () => tapped = true,
        );
        await game.pump(component);

        final shareLink =
            component.descendants().whereType<ShareLinkComponent>().first;

        shareLink.onTapDown(tapDownInfo);

        expect(tapped, isTrue);
      },
    );

    flameTester.test(
      'open Google IO Event url when navigating',
      (game) async {
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

        final component = GameOverInfoDisplay();
        await game.pump(component);

        final googleLink =
            component.descendants().whereType<GoogleIOLinkComponent>().first;
        googleLink.onTapDown(_MockTapDownInfo());

        await game.ready();

        verify(
          () => urlLauncher.launch(
            ShareRepository.googleIOEvent,
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

    flameTester.test(
      'open OpenSource url when navigating',
      (game) async {
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

        final component = GameOverInfoDisplay();
        await game.pump(component);

        final openSourceLink =
            component.descendants().whereType<OpenSourceTextComponent>().first;
        openSourceLink.onTapDown(_MockTapDownInfo());

        await game.ready();

        verify(
          () => urlLauncher.launch(
            ShareRepository.openSourceCode,
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
