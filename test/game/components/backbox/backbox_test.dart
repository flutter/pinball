// ignore_for_file: cascade_invocations, prefer_const_constructors

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/components/backbox/bloc/backbox_bloc.dart';
import 'package:pinball/game/components/backbox/displays/displays.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;
import 'package:pinball_ui/pinball_ui.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_repository/share_repository.dart';

class _TestGame extends Forge2DGame
    with HasKeyboardHandlerComponents, TapCallbacks {
  final character = theme.DashTheme();

  @override
  Color backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll([
      character.leaderboardIcon.keyName,
      Assets.images.backbox.marquee.keyName,
      Assets.images.backbox.displayDivider.keyName,
      Assets.images.backbox.button.facebook.keyName,
      Assets.images.backbox.button.twitter.keyName,
      Assets.images.backbox.displayTitleDecoration.keyName,
      Assets.images.displayArrows.arrowLeft.keyName,
      Assets.images.displayArrows.arrowRight.keyName,
    ]);
  }

  Future<void> pump(
    Backbox component, {
    PlatformHelper? platformHelper,
  }) async {
    overlays.addEntry(
      'mobile_controls',
      (context, game) {
        return PinballButton(
          text: 'mobile',
          onTap: () {},
        );
      },
    );
    overlays.addEntry(
      'replay_button',
      (context, game) {
        return PinballButton(
          text: 'replay',
          onTap: () {},
        );
      },
    );
    await world.ensureAdd(
      FlameBlocProvider<GameBloc, GameState>.value(
        value: GameBloc(),
        children: [
          MultiFlameProvider(
            providers: [
              FlameProvider<AppLocalizations>.value(
                _MockAppLocalizations(),
              ),
              FlameProvider<PlatformHelper>.value(
                platformHelper ?? _MockPlatformHelper(),
              ),
            ],
            children: [component],
          ),
        ],
      ),
    );
  }
}

class _MockKeyUpEvent extends Mock implements KeyUpEvent {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

KeyUpEvent _mockKeyUp(LogicalKeyboardKey key) {
  final event = _MockKeyUpEvent();
  when(() => event.logicalKey).thenReturn(key);
  return event;
}

class _MockPlatformHelper extends Mock implements PlatformHelper {}

class _MockBackboxBloc extends Mock implements BackboxBloc {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockShareRepository extends Mock implements ShareRepository {}

class _MockTapDownEvent extends Mock implements TapDownEvent {}

class _MockTapUpEvent extends Mock implements TapUpEvent {}

class _MockLaunchOptions extends Mock implements LaunchOptions {}

class _MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {}

class _MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get score => '';

  @override
  String get name => '';

  @override
  String get rank => '';

  @override
  String get enterInitials => '';

  @override
  String get arrows => '';

  @override
  String get andPress => '';

  @override
  String get enterReturn => '';

  @override
  String get toSubmit => '';

  @override
  String get loading => '';

  @override
  String get letEveryone => '';

  @override
  String get bySharingYourScore => '';

  @override
  String get socialMediaAccount => '';

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

  @override
  String get initialsErrorTitle => '';

  @override
  String get initialsErrorMessage => '';

  @override
  String get leaderboardErrorMessage => '';

  @override
  String iGotScoreAtPinball(String _) => '';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final flameTester = FlameTester(_TestGame.new);

  late BackboxBloc bloc;
  late PlatformHelper platformHelper;
  late UrlLauncherPlatform urlLauncher;

  setUp(() {
    bloc = _MockBackboxBloc();
    platformHelper = _MockPlatformHelper();
    whenListen(
      bloc,
      Stream<BackboxState>.empty(),
      initialState: LoadingState(),
    );
    when(() => platformHelper.isMobile).thenReturn(false);
  });

  setUpAll(() {
    registerFallbackValue(_MockLaunchOptions());
  });

  group('Backbox', () {
    flameTester.testGameWidget(
      'loads correctly',
      setUp: (game, _) async {
        await game.onLoad();
        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
      },
      verify: (game, _) async {
        expect(game.descendants().whereType<Backbox>(), isNotEmpty);
      },
    );

    flameTester.testGameWidget(
      'renders correctly',
      setUp: (game, tester) async {
        await game.onLoad();
        game.camera
          ..moveTo(Vector2(0, -130))
          ..viewfinder.zoom = 6;
        await game.pump(
          Backbox.test(
            bloc: bloc,
            shareRepository: _MockShareRepository(),
          ),
          platformHelper: platformHelper,
        );
        await tester.pump();
        await game.ready();
        game.update(0);
      },
      verify: (game, tester) async {
        await expectLater(
          find.byGame<_TestGame>(),
          matchesGoldenFile('../golden/backbox.png'),
        );
      },
    );

    flameTester.testGameWidget(
      'requestInitials adds InitialsInputDisplay',
      setUp: (game, _) async {
        await game.onLoad();
        final backbox = Backbox.test(
          bloc: BackboxBloc(
            leaderboardRepository: _MockLeaderboardRepository(),
            initialEntries: [LeaderboardEntryData.empty],
          ),
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        backbox.requestInitials(
          score: 0,
          character: game.character,
        );
        await game.ready();
      },
      verify: (game, tester) async {
        expect(
          game
              .descendants()
              .whereType<Backbox>()
              .single
              .descendants()
              .whereType<InitialsInputDisplay>()
              .length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'adds PlayerInitialsSubmitted when initials are submitted',
      setUp: (game, _) async {
        await game.onLoad();
        final state = InitialsFormState(
          score: 10,
          character: game.character,
        );
        whenListen(
          bloc,
          Stream<BackboxState>.empty(),
          initialState: state,
        );
        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, tester) async {
        game.onKeyEvent(_mockKeyUp(LogicalKeyboardKey.enter), {});
        verify(
          () => bloc.add(
            PlayerInitialsSubmitted(
              score: 10,
              initials: 'AAA',
              character: game.character,
            ),
          ),
        ).called(1);
      },
    );

    flameTester.testGameWidget(
      'adds GameOverInfoDisplay when InitialsSuccessState',
      setUp: (game, _) async {
        await game.onLoad();
        final state = InitialsSuccessState(score: 100);
        whenListen(
          bloc,
          const Stream<InitialsSuccessState>.empty(),
          initialState: state,
        );
        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<GameOverInfoDisplay>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'adds the mobile controls overlay '
      'when platform is mobile at InitialsFormState',
      setUp: (game, _) async {
        await game.onLoad();
        final platformHelper = _MockPlatformHelper();
        final state = InitialsFormState(
          score: 10,
          character: game.character,
        );
        whenListen(
          bloc,
          Stream<BackboxState>.empty(),
          initialState: state,
        );
        when(() => platformHelper.isMobile).thenReturn(true);
        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, _) async {
        expect(
          game.overlays.activeOverlays.first,
          contains(PinballGame.mobileControlsOverlay),
        );
      },
    );

    flameTester.testGameWidget(
      'remove the mobile controls overlay '
      'when InitialsSuccessState',
      setUp: (game, _) async {
        await game.onLoad();
        final platformHelper = _MockPlatformHelper();
        final state = InitialsSuccessState(score: 10);
        whenListen(
          bloc,
          Stream<BackboxState>.empty(),
          initialState: state,
        );
        when(() => platformHelper.isMobile).thenReturn(true);
        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, _) async {
        expect(
          game.overlays.activeOverlays.first,
          isNot(contains(PinballGame.mobileControlsOverlay)),
        );
      },
    );

    flameTester.testGameWidget(
      'adds InitialsSubmissionSuccessDisplay on InitialsSuccessState',
      setUp: (game, _) async {
        await game.onLoad();
        final state = InitialsSuccessState(score: 100);
        whenListen(
          bloc,
          const Stream<InitialsSuccessState>.empty(),
          initialState: state,
        );
        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<GameOverInfoDisplay>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'adds ShareScoreRequested event when sharing',
      setUp: (game, _) async {
        await game.onLoad();
        final state = InitialsSuccessState(score: 100);
        whenListen(
          bloc,
          Stream.value(state),
          initialState: state,
        );
        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );

        final shareLink =
            game.descendants().whereType<ShareLinkComponent>().first;
        shareLink.onTapDown(_MockTapDownEvent());
        await game.ready();
      },
      verify: (game, tester) async {
        final state = bloc.state as InitialsSuccessState;
        game.update(0);
        await tester.pump();
        verify(
          () => bloc.add(
            ShareScoreRequested(score: state.score),
          ),
        ).called(1);
      },
    );

    flameTester.testGameWidget(
      'adds InitialsSubmissionFailureDisplay on InitialsFailureState',
      setUp: (game, _) async {
        await game.onLoad();
        whenListen(
          bloc,
          Stream<BackboxState>.empty(),
          initialState: InitialsFailureState(
            score: 0,
            character: theme.DashTheme(),
          ),
        );
        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, _) async {
        expect(
          game
              .descendants()
              .whereType<InitialsSubmissionFailureDisplay>()
              .length,
          equals(1),
        );
      },
    );

    group('ShareDisplay', () {
      setUp(() async {
        urlLauncher = _MockUrlLauncher();
        UrlLauncherPlatform.instance = urlLauncher;
      });

      flameTester.testGameWidget(
        'adds ShareDisplay on ShareState',
        setUp: (game, _) async {
          await game.onLoad();
          final state = ShareState(score: 100);
          whenListen(
            bloc,
            const Stream<InitialsSuccessState>.empty(),
            initialState: state,
          );
          final backbox = Backbox.test(
            bloc: bloc,
            shareRepository: _MockShareRepository(),
          );
          await game.pump(
            backbox,
            platformHelper: platformHelper,
          );
          await game.ready();
        },
        verify: (game, _) async {
          expect(
            game.descendants().whereType<ShareDisplay>().length,
            equals(1),
          );
        },
      );

      flameTester.testGameWidget(
        'opens Facebook link when sharing with Facebook',
        setUp: (game, _) async {
          await game.onLoad();
          when(() => urlLauncher.canLaunch(any()))
              .thenAnswer((_) async => true);
          when(
            () => urlLauncher.launchUrl(
              any(),
              any(),
            ),
          ).thenAnswer((_) async => true);

          final state = ShareState(score: 100);
          whenListen(
            bloc,
            const Stream<ShareState>.empty(),
            initialState: state,
          );

          final shareRepository = _MockShareRepository();
          const fakeUrl = 'http://fakeUrl';
          when(
            () => shareRepository.shareText(
              value: any(named: 'value'),
              platform: SharePlatform.facebook,
            ),
          ).thenReturn(fakeUrl);

          final backbox = Backbox.test(
            bloc: bloc,
            shareRepository: shareRepository,
          );
          await game.pump(
            backbox,
            platformHelper: platformHelper,
          );

          expect(bloc.state, isA<ShareState>());

          final facebookButton =
              game.descendants().whereType<FacebookButtonComponent>().first;
          facebookButton.onTapUp(_MockTapUpEvent());

          await game.ready();

          verify(
            () => shareRepository.shareText(
              value: any(named: 'value'),
              platform: SharePlatform.facebook,
            ),
          ).called(1);
        },
      );

      flameTester.testGameWidget(
        'opens Twitter link when sharing with Twitter',
        setUp: (game, tester) async {
          await game.onLoad();
          final state = ShareState(score: 100);
          whenListen(
            bloc,
            Stream.value(state),
            initialState: state,
          );

          final shareRepository = _MockShareRepository();
          const fakeUrl = 'http://fakeUrl';
          when(
            () => shareRepository.shareText(
              value: any(named: 'value'),
              platform: SharePlatform.twitter,
            ),
          ).thenReturn(fakeUrl);
          when(() => urlLauncher.canLaunch(any()))
              .thenAnswer((_) async => true);
          when(
            () => urlLauncher.launchUrl(
              any(),
              any(),
            ),
          ).thenAnswer((_) async => true);

          final backbox = Backbox.test(
            bloc: bloc,
            shareRepository: shareRepository,
          );
          await game.pump(
            backbox,
            platformHelper: platformHelper,
          );

          expect(bloc.state, isA<ShareState>());

          final twitterButton =
              game.descendants().whereType<TwitterButtonComponent>().first;
          twitterButton.onTapUp(_MockTapUpEvent());

          await game.ready();
          verify(
            () => shareRepository.shareText(
              value: any(named: 'value'),
              platform: SharePlatform.twitter,
            ),
          ).called(1);
        },
      );
    });

    flameTester.testGameWidget(
      'adds LeaderboardDisplay on LeaderboardSuccessState',
      setUp: (game, _) async {
        await game.onLoad();
        whenListen(
          bloc,
          Stream<BackboxState>.empty(),
          initialState: LeaderboardSuccessState(entries: const []),
        );

        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<LeaderboardDisplay>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'adds LeaderboardFailureDisplay on LeaderboardFailureState',
      setUp: (game, _) async {
        await game.onLoad();
        whenListen(
          bloc,
          Stream<BackboxState>.empty(),
          initialState: LeaderboardFailureState(),
        );

        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<LeaderboardFailureDisplay>().length,
          equals(1),
        );
      },
    );

    flameTester.testGameWidget(
      'closes the subscription when it is removed',
      setUp: (game, _) async {
        await game.onLoad();
        final streamController = StreamController<BackboxState>();
        whenListen(
          bloc,
          streamController.stream,
          initialState: LoadingState(),
        );

        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );

        backbox.removeFromParent();
        await game.ready();

        streamController.add(
          InitialsFailureState(
            score: 10,
            character: theme.DashTheme(),
          ),
        );
        await game.ready();

        expect(
          backbox
              .descendants()
              .whereType<InitialsSubmissionFailureDisplay>()
              .isEmpty,
          isTrue,
        );
      },
    );

    flameTester.testGameWidget(
      'adds PlayerInitialsSubmitted when the timer is finished',
      setUp: (game, _) async {
        await game.onLoad();
        final initialState = InitialsFailureState(
          score: 10,
          character: theme.DashTheme(),
        );
        whenListen(
          bloc,
          Stream<BackboxState>.fromIterable([]),
          initialState: initialState,
        );

        final backbox = Backbox.test(
          bloc: bloc,
          shareRepository: _MockShareRepository(),
        );
        await game.pump(
          backbox,
          platformHelper: platformHelper,
        );
        await game.ready();
      },
      verify: (game, _) async {
        game.update(4);
        verify(
          () => bloc.add(
            PlayerInitialsRequested(
              score: 10,
              character: theme.DashTheme(),
            ),
          ),
        ).called(1);
      },
    );
  });
}
