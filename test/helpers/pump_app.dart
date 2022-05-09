import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/assets_manager/assets_manager.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:platform_helper/platform_helper.dart';
import 'package:share_repository/share_repository.dart';

class _MockAssetsManagerCubit extends Mock implements AssetsManagerCubit {}

class _MockLeaderboardRepository extends Mock implements LeaderboardRepository {
}

class _MockShareRepository extends Mock implements ShareRepository {}

class _MockCharacterThemeCubit extends Mock implements CharacterThemeCubit {}

class _MockGameBloc extends Mock implements GameBloc {}

class _MockStartGameBloc extends Mock implements StartGameBloc {}

class _MockPinballAudioPlayer extends Mock implements PinballAudioPlayer {}

class _MockPlatformHelper extends Mock implements PlatformHelper {}

PinballAudioPlayer _buildDefaultPinballAudioPlayer() {
  final audioPlayer = _MockPinballAudioPlayer();
  when(audioPlayer.load).thenAnswer((_) => [Future.value]);
  return audioPlayer;
}

AssetsManagerCubit _buildDefaultAssetsManagerCubit() {
  final cubit = _MockAssetsManagerCubit();
  const state = AssetsManagerState(
    assetsCount: 1,
    loaded: 1,
  );
  whenListen(
    cubit,
    Stream.value(state),
    initialState: state,
  );

  return cubit;
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    GameBloc? gameBloc,
    StartGameBloc? startGameBloc,
    AssetsManagerCubit? assetsManagerCubit,
    CharacterThemeCubit? characterThemeCubit,
    LeaderboardRepository? leaderboardRepository,
    ShareRepository? shareRepository,
    PinballAudioPlayer? pinballAudioPlayer,
    PlatformHelper? platformHelper,
  }) {
    return runAsync(() {
      return pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: leaderboardRepository ?? _MockLeaderboardRepository(),
            ),
            RepositoryProvider.value(
              value: shareRepository ?? _MockShareRepository(),
            ),
            RepositoryProvider.value(
              value: pinballAudioPlayer ?? _buildDefaultPinballAudioPlayer(),
            ),
            RepositoryProvider.value(
              value: platformHelper ?? _MockPlatformHelper(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: characterThemeCubit ?? _MockCharacterThemeCubit(),
              ),
              BlocProvider.value(
                value: gameBloc ?? _MockGameBloc(),
              ),
              BlocProvider.value(
                value: startGameBloc ?? _MockStartGameBloc(),
              ),
              BlocProvider.value(
                value: assetsManagerCubit ?? _buildDefaultAssetsManagerCubit(),
              ),
            ],
            child: MaterialApp(
              theme: PinballTheme.standard,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: widget,
            ),
          ),
        ),
      );
    });
  }
}
