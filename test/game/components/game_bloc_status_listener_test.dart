// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' as theme;
import 'package:pinball_ui/pinball_ui.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:share_repository/share_repository.dart';

class _TestGame extends Forge2DGame with TapCallbacks {
  @override
  Future<void> onLoad() async {
    images.prefix = '';
    await images.loadAll(
      [
        const theme.DashTheme().leaderboardIcon.keyName,
        Assets.images.backbox.marquee.keyName,
        Assets.images.backbox.displayDivider.keyName,
        Assets.images.displayArrows.arrowLeft.keyName,
        Assets.images.displayArrows.arrowRight.keyName,
      ],
    );
  }

  Future<void> pump(
    Iterable<Component> children, {
    PinballAudioPlayer? pinballAudioPlayer,
    GoogleWordCubit? googleWordBloc,
    DashBumpersCubit? dashBumpersBloc,
    SignpostCubit? signpostBloc,
  }) async {
    overlays.addEntry(
      'mobile_controls',
      (context, game) {
        return PinballButton(
          text: 'enter',
          onTap: () => {},
        );
      },
    );
    return ensureAdd(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, GameState>.value(
            value: GameBloc(),
          ),
          FlameBlocProvider<CharacterThemeCubit, CharacterThemeState>.value(
            value: CharacterThemeCubit(),
          ),
          FlameBlocProvider<GoogleWordCubit, GoogleWordState>.value(
            value: googleWordBloc ?? GoogleWordCubit(),
          ),
          FlameBlocProvider<DashBumpersCubit, DashBumpersState>.value(
            value: dashBumpersBloc ?? DashBumpersCubit(),
          ),
          FlameBlocProvider<SignpostCubit, SignpostState>.value(
            value: signpostBloc ?? SignpostCubit(),
          ),
        ],
        children: [
          MultiFlameProvider(
            providers: [
              FlameProvider<PinballAudioPlayer>.value(
                pinballAudioPlayer ?? _MockPinballAudioPlayer(),
              ),
              FlameProvider<AppLocalizations>.value(
                _MockAppLocalizations(),
              ),
              FlameProvider<PlatformHelper>.value(
                PlatformHelper(),
              ),
            ],
            children: children,
          ),
        ],
      ),
    );
  }
}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockLeaderboardRepository extends Mock
    implements LeaderboardRepository {}

class _MockShareRepository extends Mock implements ShareRepository {}

class _MockPlungerCubit extends Mock implements PlungerCubit {}

class _MockGoogleWordCubit extends Mock implements GoogleWordCubit {}

class _MockDashBumpersCubit extends Mock implements DashBumpersCubit {}

class _MockSignpostCubit extends Mock implements SignpostCubit {}

class _MockFlipperCubit extends Mock implements FlipperCubit {}

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
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GameBlocStatusListener', () {
    test('can be instantiated', () {
      expect(
        GameBlocStatusListener(),
        isA<GameBlocStatusListener>(),
      );
    });

    final flameTester = FlameTester(_TestGame.new);

    flameTester.testGameWidget(
      'can be loaded',
      setUp: (game, _) async {
        final component = GameBlocStatusListener();
        await game.pump([component]);
      },
      verify: (game, _) async {
        expect(
          game.descendants().whereType<GameBlocStatusListener>().length,
          equals(1),
        );
      },
    );

    group('listenWhen', () {
      test('is true when the game over state has changed', () {
        const state = GameState(
          totalScore: 0,
          roundScore: 10,
          multiplier: 1,
          rounds: 0,
          bonusHistory: [],
          status: GameStatus.playing,
        );

        const previous = GameState.initial();
        expect(
          GameBlocStatusListener().listenWhen(previous, state),
          isTrue,
        );
      });
    });

    group('onNewState', () {
      group('on game over', () {
        late GameState state;

        setUp(() {
          state = const GameState.initial().copyWith(
            status: GameStatus.gameOver,
          );
        });

        flameTester.testGameWidget(
          'changes the backbox display',
          setUp: (game, _) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );

            await game.pump([component, backbox]);
          },
          verify: (game, _) async {
            final component =
                game.descendants().whereType<GameBlocStatusListener>().single;
            expect(() => component.onNewState(state), returnsNormally);
          },
        );

        flameTester.testGameWidget(
          'removes FlipperKeyControllingBehavior from Flipper',
          setUp: (game, _) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );
            final flipper = Flipper.test(side: BoardSide.left);
            final behavior = FlipperKeyControllingBehavior();

            await game.pump([component, backbox, flipper]);
            await flipper.ensureAdd(
              FlameBlocProvider<FlipperCubit, FlipperState>(
                create: _MockFlipperCubit.new,
                children: [behavior],
              ),
            );

            expect(state.status, GameStatus.gameOver);
            component.onNewState(state);
            await game.ready();
          },
          verify: (game, _) async {
            final flipper = game.descendants().whereType<Flipper>().single;
            expect(
              flipper.children.whereType<FlipperKeyControllingBehavior>(),
              isEmpty,
            );
          },
        );

        flameTester.testGameWidget(
          'removes PlungerKeyControllingBehavior from Plunger',
          setUp: (game, _) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );
            final plunger = Plunger.test();
            await game.pump(
              [component, backbox, plunger],
            );

            await plunger.ensureAdd(
              FlameBlocProvider<PlungerCubit, PlungerState>(
                create: PlungerCubit.new,
                children: [PlungerKeyControllingBehavior()],
              ),
            );

            expect(state.status, GameStatus.gameOver);
            component.onNewState(state);
            await game.ready();
          },
          verify: (game, _) async {
            final plunger = game.descendants().whereType<Plunger>().single;

            expect(
              plunger.children.whereType<PlungerKeyControllingBehavior>(),
              isEmpty,
            );
          },
        );

        flameTester.testGameWidget(
          'removes PlungerPullingBehavior from Plunger',
          setUp: (game, _) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );
            final plunger = Plunger.test();
            await game.pump(
              [component, backbox, plunger],
            );

            await plunger.ensureAdd(
              FlameBlocProvider<PlungerCubit, PlungerState>(
                create: PlungerCubit.new,
                children: [
                  PlungerPullingBehavior(strength: 0),
                  PlungerAutoPullingBehavior(),
                ],
              ),
            );

            expect(state.status, GameStatus.gameOver);
            component.onNewState(state);
            await game.ready();
          },
          verify: (game, _) async {
            final plunger = game.descendants().whereType<Plunger>().single;
            expect(
              plunger.children.whereType<PlungerPullingBehavior>(),
              isEmpty,
            );
          },
        );

        flameTester.testGameWidget(
          'plays the game over voice over',
          setUp: (game, _) async {
            final audioPlayer = _MockPinballAudioPlayer();
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );
            await game.pump(
              [component, backbox],
              pinballAudioPlayer: audioPlayer,
            );
          },
          verify: (game, _) async {
            final component =
                game.descendants().whereType<GameBlocStatusListener>().single;
            final audioPlayer = game
                .descendants()
                .whereType<FlameProvider<PinballAudioPlayer>>()
                .single
                .provider;

            component.onNewState(state);

            verify(
              () => audioPlayer.play(
                PinballAudio.gameOverVoiceOver,
              ),
            ).called(1);
          },
        );
      });

      group('on playing', () {
        late GameState state;

        setUp(() {
          state = const GameState.initial().copyWith(
            status: GameStatus.playing,
          );
        });

        flameTester.testGameWidget(
          'plays the background music on start',
          setUp: (game, _) async {
            final audioPlayer = _MockPinballAudioPlayer();
            final component = GameBlocStatusListener();
            await game.pump(
              [component],
              pinballAudioPlayer: audioPlayer,
            );
          },
          verify: (game, _) async {
            final component =
                game.descendants().whereType<GameBlocStatusListener>().single;
            final audioPlayer = game
                .descendants()
                .whereType<FlameProvider<PinballAudioPlayer>>()
                .single
                .provider;
            expect(state.status, equals(GameStatus.playing));
            component.onNewState(state);

            verify(
              () => audioPlayer.play(
                PinballAudio.backgroundMusic,
              ),
            ).called(1);
          },
        );

        flameTester.testGameWidget(
          'resets the GoogleWordCubit',
          setUp: (game, _) async {
            final googleWordBloc = _MockGoogleWordCubit();
            final component = GameBlocStatusListener();
            await game.pump(
              [component],
              googleWordBloc: googleWordBloc,
            );
          },
          verify: (game, _) async {
            final component =
                game.descendants().whereType<GameBlocStatusListener>().single;
            final googleWordBloc = game
                .descendants()
                .whereType<
                    FlameBlocProvider<GoogleWordCubit, GoogleWordState>>()
                .single
                .bloc;
            expect(state.status, equals(GameStatus.playing));
            component.onNewState(state);

            verify(googleWordBloc.onReset).called(1);
          },
        );

        flameTester.testGameWidget(
          'resets the DashBumpersCubit',
          setUp: (game, _) async {
            final dashBumpersBloc = _MockDashBumpersCubit();
            final component = GameBlocStatusListener();
            await game.pump(
              [component],
              dashBumpersBloc: dashBumpersBloc,
            );
          },
          verify: (game, _) async {
            final component =
                game.descendants().whereType<GameBlocStatusListener>().single;
            final dashBumpersBloc = game
                .descendants()
                .whereType<
                    FlameBlocProvider<DashBumpersCubit, DashBumpersState>>()
                .single
                .bloc;

            expect(state.status, equals(GameStatus.playing));
            component.onNewState(state);

            verify(dashBumpersBloc.onReset).called(1);
          },
        );

        flameTester.testGameWidget(
          'resets the SignpostCubit',
          setUp: (game, _) async {
            final signpostBloc = _MockSignpostCubit();
            final component = GameBlocStatusListener();
            await game.pump([component], signpostBloc: signpostBloc);
          },
          verify: (game, _) async {
            final component =
                game.descendants().whereType<GameBlocStatusListener>().single;
            final signpostBloc = game
                .descendants()
                .whereType<FlameBlocProvider<SignpostCubit, SignpostState>>()
                .single
                .bloc;
            expect(state.status, equals(GameStatus.playing));
            component.onNewState(state);

            verify(signpostBloc.onReset).called(1);
          },
        );

        flameTester.testGameWidget(
          'adds FlipperKeyControllingBehavior to Flippers',
          setUp: (game, _) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );
            final flipper = Flipper.test(side: BoardSide.left);

            await game.pump([component, backbox, flipper]);
            await flipper.ensureAdd(
              FlameBlocProvider<FlipperCubit, FlipperState>(
                create: _MockFlipperCubit.new,
              ),
            );

            component.onNewState(state);
            await game.ready();
          },
          verify: (game, _) async {
            final flipper = game.descendants().whereType<Flipper>().single;
            expect(
              flipper
                  .descendants()
                  .whereType<FlipperKeyControllingBehavior>()
                  .length,
              equals(1),
            );
          },
        );

        flameTester.testGameWidget(
          'adds PlungerKeyControllingBehavior to Plunger',
          setUp: (game, _) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );
            final plunger = Plunger.test();
            final bloc = _MockPlungerCubit();
            whenListen(
              bloc,
              const Stream<PlungerState>.empty(),
              initialState: PlungerState.releasing,
            );
            await game.pump([component, backbox, plunger]);
            await plunger.ensureAdd(
              FlameBlocProvider<PlungerCubit, PlungerState>.value(
                value: bloc,
              ),
            );

            expect(state.status, GameStatus.playing);

            component.onNewState(state);
            await game.ready();
          },
          verify: (game, _) async {
            final plunger = game.descendants().whereType<Plunger>().single;
            expect(
              plunger
                  .descendants()
                  .whereType<PlungerKeyControllingBehavior>()
                  .length,
              equals(1),
            );
          },
        );

        flameTester.testGameWidget(
          'adds PlungerPullingBehavior to Plunger',
          setUp: (game, _) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );
            final plunger = Plunger.test();
            final bloc = _MockPlungerCubit();
            whenListen(
              bloc,
              const Stream<PlungerState>.empty(),
              initialState: PlungerState.releasing,
            );
            await game.pump([component, backbox, plunger]);
            await plunger.ensureAdd(
              FlameBlocProvider<PlungerCubit, PlungerState>.value(
                value: bloc,
              ),
            );

            expect(state.status, GameStatus.playing);

            component.onNewState(state);
            await game.ready();
          },
          verify: (game, _) async {
            final plunger = game.descendants().whereType<Plunger>().single;
            expect(
              plunger.descendants().whereType<PlungerPullingBehavior>().length,
              equals(1),
            );
          },
        );

        flameTester.testGameWidget(
          'adds PlungerAutoPullingBehavior to Plunger',
          setUp: (game, _) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );
            final bloc = _MockPlungerCubit();
            whenListen(
              bloc,
              const Stream<PlungerState>.empty(),
              initialState: PlungerState.releasing,
            );
            final plunger = Plunger.test();
            await game.pump([component, backbox, plunger]);
            await plunger.ensureAdd(
              FlameBlocProvider<PlungerCubit, PlungerState>.value(
                value: bloc,
              ),
            );

            expect(state.status, GameStatus.playing);

            component.onNewState(state);
            await game.ready();
          },
          verify: (game, _) async {
            final plunger = game.descendants().whereType<Plunger>().single;
            expect(
              plunger
                  .descendants()
                  .whereType<PlungerAutoPullingBehavior>()
                  .length,
              equals(1),
            );
          },
        );
      });
    });
  });
}
