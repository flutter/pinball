import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_ui/pinball_ui.dart';

import 'helpers.dart';

PinballAudio _buildDefaultPinballAudio() {
  final audio = MockPinballAudio();

  when(audio.load).thenAnswer((_) => Future.value());

  return audio;
}

MockAssetsManagerCubit _buildDefaultAssetsManagerCubit() {
  final cubit = MockAssetsManagerCubit();

  final state = AssetsManagerState(
    loadables: [Future<void>.value()],
    loaded: [
      Future<void>.value(),
    ],
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
    PinballAudio? pinballAudio,
  }) {
    return runAsync(() {
      return pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(
              value: leaderboardRepository ?? MockLeaderboardRepository(),
            ),
            RepositoryProvider.value(
              value: pinballAudio ?? _buildDefaultPinballAudio(),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: characterThemeCubit ?? MockCharacterThemeCubit(),
              ),
              BlocProvider.value(
                value: gameBloc ?? MockGameBloc(),
              ),
              BlocProvider.value(
                value: startGameBloc ?? MockStartGameBloc(),
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
