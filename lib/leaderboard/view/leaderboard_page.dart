// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template leaderboard_page}
/// Shows the leaderboard page of [Competitor]s.
/// {@endtemplate}
class LeaderboardPage extends StatelessWidget {
  /// {@macro leaderboard_page}
  const LeaderboardPage({Key? key, required this.theme}) : super(key: key);

  /// Current [CharacterTheme] to customize screen
  final CharacterTheme theme;

  static Route route({required CharacterTheme theme}) {
    return MaterialPageRoute<void>(
      builder: (_) => LeaderboardPage(theme: theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LeaderboardView(theme: theme);
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({Key? key, required this.theme}) : super(key: key);

  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Text(
                l10n.leadersboard,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 80),
              _LeaderboardRanking(theme: theme),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).push<void>(
                  CharacterSelectionPage.route(),
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardRanking extends StatelessWidget {
  const _LeaderboardRanking({Key? key, required this.theme}) : super(key: key);

  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LeaderboardHeaders(theme: theme),
          _LeaderboardList(theme: theme),
        ],
      ),
    );
  }
}

class _LeaderboardHeaders extends StatelessWidget {
  const _LeaderboardHeaders({Key? key, required this.theme}) : super(key: key);

  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LeaderboardHeaderItem(title: l10n.rank, theme: theme),
        _LeaderboardHeaderItem(title: l10n.character, theme: theme),
        _LeaderboardHeaderItem(title: l10n.userName, theme: theme),
        _LeaderboardHeaderItem(title: l10n.score, theme: theme),
      ],
    );
  }
}

class _LeaderboardHeaderItem extends StatelessWidget {
  const _LeaderboardHeaderItem({
    Key? key,
    required this.title,
    required this.theme,
  }) : super(key: key);

  final CharacterTheme theme;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.ballColor,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({Key? key, required this.theme}) : super(key: key);

  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (_, index) => _LeaderBoardCompetitor(
        competitor: Competitor(
          rank: (index + 1).toString(),
          entry: LeaderboardEntry(
            character: CharacterType.android,
            playerInitials: 'user$index',
            score: 0,
          ),
        ),
        theme: theme,
      ),
      itemCount: 10,
    );
  }
}

class _LeaderBoardCompetitor extends StatelessWidget {
  const _LeaderBoardCompetitor({
    Key? key,
    required this.competitor,
    required this.theme,
  }) : super(key: key);

  final CharacterTheme theme;

  final Competitor competitor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LeaderboardCompetitorField(
          text: competitor.rank,
          theme: theme,
        ),
        _LeaderboardCompetitorCharacter(
          characterTheme: competitor.entry.character.theme,
          theme: theme,
        ),
        _LeaderboardCompetitorField(
          text: competitor.entry.playerInitials,
          theme: theme,
        ),
        _LeaderboardCompetitorField(
          text: competitor.entry.score.toString(),
          theme: theme,
        ),
      ],
    );
  }
}

class _LeaderboardCompetitorField extends StatelessWidget {
  const _LeaderboardCompetitorField({
    Key? key,
    required this.text,
    required this.theme,
  }) : super(key: key);

  final CharacterTheme theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.ballColor,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(text),
        ),
      ),
    );
  }
}

class _LeaderboardCompetitorCharacter extends StatelessWidget {
  const _LeaderboardCompetitorCharacter({
    Key? key,
    required this.characterTheme,
    required this.theme,
  }) : super(key: key);

  final CharacterTheme theme;
  final CharacterTheme characterTheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.ballColor,
            width: 2,
          ),
        ),
        child: SizedBox(
          height: 30,
          child: characterTheme.characterAsset.image(),
        ),
      ),
    );
  }
}

// TODO(ruimiguel): move below model and extensions to LeaderboardState
class Competitor {
  Competitor({required this.rank, required this.entry});

  final String rank;
  final LeaderboardEntry entry;
}

extension CharacterTypeX on CharacterType {
  CharacterTheme get theme {
    switch (this) {
      case CharacterType.dash:
        return const DashTheme();
      case CharacterType.sparky:
        return const SparkyTheme();
      case CharacterType.android:
        return const AndroidTheme();
      case CharacterType.dino:
        return const DinoTheme();
    }
  }
}

extension CharacterThemeX on CharacterTheme {
  CharacterType get toType {
    switch (runtimeType) {
      case DashTheme:
        return CharacterType.dash;
      case SparkyTheme:
        return CharacterType.sparky;
      case AndroidTheme:
        return CharacterType.android;
      case DinoTheme:
        return CharacterType.dino;
      default:
        return CharacterType.dash;
    }
  }
}
