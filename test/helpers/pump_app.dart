// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_audio/pinball_audio.dart';

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
    MockNavigator? navigator,
    GameBloc? gameBloc,
    AssetsManagerCubit? assetsManagerCubit,
    ThemeCubit? themeCubit,
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
                value: themeCubit ?? MockThemeCubit(),
              ),
              BlocProvider.value(
                value: gameBloc ?? MockGameBloc(),
              ),
              BlocProvider.value(
                value: assetsManagerCubit ?? _buildDefaultAssetsManagerCubit(),
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: navigator != null
                  ? MockNavigatorProvider(navigator: navigator, child: widget)
                  : widget,
            ),
          ),
        ),
      );
    });
  }
}
