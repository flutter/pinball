// ignore_for_file: cascade_invocations

import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/displays/game_over_info_display.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_repository/share_repository.dart';

class _TestGame extends Forge2DGame with TapCallbacks {
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
    overlays.addEntry(
      'replay_button',
      (context, game) {
        return PinballButton(
          text: 'replay',
          onTap: () {},
        );
      },
    );
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

class _MockTapDownEvent extends Mock implements TapDownEvent {}

class _MockTapUpEvent extends Mock implements TapUpEvent {}

class _MockLaunchOptions extends Mock implements LaunchOptions {}

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

  setUpAll(() {
    registerFallbackValue(_MockLaunchOptions());
  });

  group('InfoDisplay', () {
    var tapped = false;
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        final component = GameOverInfoDisplay();
        await game.pump(component);
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<GameOverInfoDisplay>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'calls onShare when Share link is tapped',
      setUp: (game, _) async {
        await game.onLoad();
        tapped = false;
        final component = GameOverInfoDisplay(
          onShare: () => tapped = true,
        );
        await game.pump(component);
        await game.ready();
      },
      verify: (game, _) async {
        final tapDownEvent = _MockTapDownEvent();
        final component =
            game.descendants().whereType<GameOverInfoDisplay>().single;
        final shareLink =
            component.descendants().whereType<ShareLinkComponent>().first;

        shareLink.onTapDown(tapDownEvent);

        expect(tapped, isTrue);
      },
    );

    flameTester.testGameWidget(
      'open Google IO Event url when navigating',
      setUp: (game, _) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
        when(
          () => urlLauncher.launchUrl(any(), any()),
        ).thenAnswer((_) => Future<bool>.value(true));

        final component = GameOverInfoDisplay();
        await game.pump(component);
        await game.ready();
      },
      verify: (game, tester) async {
        final component =
            game.descendants().whereType<GameOverInfoDisplay>().single;
        final googleLink =
            component.descendants().whereType<GoogleIOLinkComponent>().first;
        googleLink.onTapUp(_MockTapUpEvent());

        game.update(0);

        await tester.pump();

        verify(
          () => urlLauncher.launchUrl(
            ShareRepository.googleIOEvent,
            any(),
          ),
        );
      },
    );

    flameTester.testGameWidget(
      'open OpenSource url when navigating',
      setUp: (game, _) async {
        when(() => urlLauncher.canLaunch(any())).thenAnswer((_) async => true);
        when(
          () => urlLauncher.launchUrl(any(), any()),
        ).thenAnswer((_) async => true);

        final component = GameOverInfoDisplay();
        await game.pump(component);

        await game.ready();
      },
      verify: (game, tester) async {
        final component =
            game.descendants().whereType<GameOverInfoDisplay>().single;
        final openSourceLink =
            component.descendants().whereType<OpenSourceTextComponent>().first;
        openSourceLink.onTapUp(_MockTapUpEvent());

        game.update(0);
        await tester.pump();

        verify(
          () => urlLauncher.launchUrl(ShareRepository.openSourceCode, any()),
        );
      },
    );
  });
}
