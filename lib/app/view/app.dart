// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/landing/landing.dart';
import 'package:pinball_audio/pinball_audio.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required LeaderboardRepository leaderboardRepository,
    required PinballAudio pinballAudio,
  })  : _leaderboardRepository = leaderboardRepository,
        _pinballAudio = pinballAudio,
        super(key: key);

  final LeaderboardRepository _leaderboardRepository;
  final PinballAudio _pinballAudio;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _leaderboardRepository),
        RepositoryProvider.value(value: _pinballAudio),
      ],
      child: MaterialApp(
        title: 'I/O Pinball',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LandingPage(),
      ),
    );
  }
}
