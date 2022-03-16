import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  ///
  static Route route({required CharacterTheme theme}) {
    return MaterialPageRoute<void>(
      builder: (_) => LeaderboardPage(theme: theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit()..characterSelected(theme),
      child: const LeaderboardView(),
    );
  }
}

/// View for leaderboard.
class LeaderboardView extends StatelessWidget {
  const LeaderboardView({Key? key}) : super(key: key);

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
                l10n.leadersBoard,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 80),
              const _LeaderboardRanking(),
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
  const _LeaderboardRanking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          _LeaderboardHeaders(),
          _LeaderboardList(),
        ],
      ),
    );
  }
}

class _LeaderboardHeaders extends StatelessWidget {
  const _LeaderboardHeaders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LeaderboardHeaderItem(title: l10n.rank),
        _LeaderboardHeaderItem(title: l10n.character),
        _LeaderboardHeaderItem(title: l10n.userName),
        _LeaderboardHeaderItem(title: l10n.score),
      ],
    );
  }
}

class _LeaderboardHeaderItem extends StatelessWidget {
  const _LeaderboardHeaderItem({Key? key, required this.title})
      : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              context.read<ThemeCubit>().state.theme.characterTheme.ballColor,
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
  const _LeaderboardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (_, index) => _LeaderBoardCompetitor(
        competitor: Competitor(
          rank: index,
          characterTheme: const SparkyTheme(),
          initials: 'user$index',
          score: 0,
        ),
      ),
      itemCount: 10,
    );
  }
}

class _LeaderBoardCompetitor extends StatelessWidget {
  const _LeaderBoardCompetitor({Key? key, required this.competitor})
      : super(key: key);

  final Competitor competitor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LeaderboardCompetitorField(text: competitor.rank.toString()),
        _LeaderboardCompetitorCharacter(
          characterTheme: competitor.characterTheme,
        ),
        _LeaderboardCompetitorField(text: competitor.initials),
        _LeaderboardCompetitorField(text: competitor.score.toString()),
      ],
    );
  }
}

class _LeaderboardCompetitorField extends StatelessWidget {
  const _LeaderboardCompetitorField({Key? key, required this.text})
      : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color:
                context.read<ThemeCubit>().state.theme.characterTheme.ballColor,
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
  }) : super(key: key);
  final CharacterTheme characterTheme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color:
                context.read<ThemeCubit>().state.theme.characterTheme.ballColor,
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

/// {@template competitor}
/// Class for players at ranking table.
/// {@endtemplate}
class Competitor {
  /// {@macro competitor}
  Competitor({
    required this.rank,
    required this.characterTheme,
    required this.initials,
    required this.score,
  });

  /// [Competitor]'s position at ranking table.
  final int rank;

  /// [Competitor]'s selected [CharacterTheme].
  final CharacterTheme characterTheme;

  /// [Competitor]'s name initials.
  final String initials;

  /// [Competitor]'s final score.
  final int score;
}
