// ignore_for_file: cascade_invocations

import 'package:flame/components.dart';
import 'package:flame/game.dart';
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
import 'package:platform_helper/platform_helper.dart';
import 'package:share_repository/share_repository.dart';

class _TestGame extends Forge2DGame with HasTappables {
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
  }) async {
    return ensureAdd(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameBloc, GameState>.value(
            value: GameBloc(),
          ),
          FlameBlocProvider<CharacterThemeCubit, CharacterThemeState>.value(
            value: CharacterThemeCubit(),
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
                _MockPlatformHelper(),
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

class _MockLeaderboardRepository extends Mock implements LeaderboardRepository {
}

class _MockShareRepository extends Mock implements ShareRepository {}

class _MockPlatformHelper extends Mock implements PlatformHelper {
  @override
  bool get isMobile => false;
}

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

    flameTester.test(
      'can be loaded',
      (game) async {
        final component = GameBlocStatusListener();
        await game.pump([component]);
        expect(game.descendants(), contains(component));
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

        flameTester.test(
          'changes the backbox display',
          (game) async {
            final component = GameBlocStatusListener();
            final leaderboardRepository = _MockLeaderboardRepository();
            final shareRepository = _MockShareRepository();
            final backbox = Backbox(
              leaderboardRepository: leaderboardRepository,
              shareRepository: shareRepository,
              entries: const [],
            );

            await game.pump([component, backbox]);

            expect(() => component.onNewState(state), returnsNormally);
          },
        );

        flameTester.test(
          'removes FlipperKeyControllingBehavior from Flipper',
          (game) async {
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
            await flipper.ensureAdd(behavior);

            expect(state.status, GameStatus.gameOver);

            component.onNewState(state);
            await game.ready();

            expect(
              flipper.children.whereType<FlipperKeyControllingBehavior>(),
              isEmpty,
            );
          },
        );

        flameTester.test(
          'plays the game over voice over',
          (game) async {
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

        flameTester.test(
          'plays the background music on start',
          (game) async {
            final audioPlayer = _MockPinballAudioPlayer();
            final component = GameBlocStatusListener();
            await game.pump([component], pinballAudioPlayer: audioPlayer);

            expect(state.status, equals(GameStatus.playing));
            component.onNewState(state);

            verify(
              () => audioPlayer.play(
                PinballAudio.backgroundMusic,
              ),
            ).called(1);
          },
        );

        flameTester.test(
          'adds key controlling behavior to Flippers when the game is started',
          (game) async {
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

            component.onNewState(state);
            await game.ready();

            expect(
              flipper.children
                  .whereType<FlipperKeyControllingBehavior>()
                  .length,
              equals(1),
            );
          },
        );
      });
    });
  });
}
