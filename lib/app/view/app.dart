// ignore_for_file: public_member_api_docs

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/select_character/select_character.dart';
import 'package:pinball/start_game/start_game.dart';
import 'package:pinball_audio/pinball_audio.dart';
import 'package:pinball_ui/pinball_ui.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthenticationRepository authenticationRepository,
    required LeaderboardRepository leaderboardRepository,
    required PinballAudio pinballAudio,
  })  : _authenticationRepository = authenticationRepository,
        _leaderboardRepository = leaderboardRepository,
        _pinballAudio = pinballAudio,
        super(key: key);

  final AuthenticationRepository _authenticationRepository;
  final LeaderboardRepository _leaderboardRepository;
  final PinballAudio _pinballAudio;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authenticationRepository),
        RepositoryProvider.value(value: _leaderboardRepository),
        RepositoryProvider.value(value: _pinballAudio),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CharacterThemeCubit()),
          BlocProvider(create: (_) => StartGameBloc()),
        ],
        child: MaterialApp(
          title: 'I/O Pinball',
          theme: PinballTheme.standard,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PinballGamePage(),
        ),
      ),
    );
  }
}
