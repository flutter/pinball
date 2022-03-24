// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/leaderboard/leaderboard.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_theme/pinball_theme.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key, required this.theme}) : super(key: key);

  final CharacterTheme theme;

  static Route route({required CharacterTheme theme}) {
    return MaterialPageRoute<void>(
      builder: (_) => LeaderboardPage(theme: theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        context.read<LeaderboardRepository>(),
      )..add(const Top10Fetched()),
      child: LeaderboardView(theme: theme),
    );
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
                l10n.leaderboard,
                style: Theme.of(context).textTheme.headline3,
              ),
              const SizedBox(height: 80),
              BlocBuilder<LeaderboardBloc, LeaderboardState>(
                builder: (context, state) {
                  switch (state.status) {
                    case LeaderboardStatus.loading:
                      return _LeaderboardLoading(theme: theme);
                    case LeaderboardStatus.success:
                      return _LeaderboardRanking(
                        ranking: state.leaderboard,
                        theme: theme,
                      );
                    case LeaderboardStatus.error:
                      return _LeaderboardError(theme: theme);
                  }
                },
              ),
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

class _LeaderboardLoading extends StatelessWidget {
  const _LeaderboardLoading({Key? key, required this.theme}) : super(key: key);

  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _LeaderboardError extends StatelessWidget {
  const _LeaderboardError({Key? key, required this.theme}) : super(key: key);

  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        'There was en error loading data!',
        style:
            Theme.of(context).textTheme.headline6?.copyWith(color: Colors.red),
      ),
    );
  }
}

class _LeaderboardRanking extends StatelessWidget {
  const _LeaderboardRanking({
    Key? key,
    required this.ranking,
    required this.theme,
  }) : super(key: key);

  final List<LeaderboardEntry> ranking;
  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LeaderboardHeaders(theme: theme),
          _LeaderboardList(
            ranking: ranking,
            theme: theme,
          ),
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
        _LeaderboardHeaderItem(title: l10n.username, theme: theme),
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
  const _LeaderboardList({
    Key? key,
    required this.ranking,
    required this.theme,
  }) : super(key: key);

  final List<LeaderboardEntry> ranking;
  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (_, index) => _LeaderBoardCompetitor(
        entry: ranking[index],
        theme: theme,
      ),
      itemCount: ranking.length,
    );
  }
}

class _LeaderBoardCompetitor extends StatelessWidget {
  const _LeaderBoardCompetitor({
    Key? key,
    required this.entry,
    required this.theme,
  }) : super(key: key);

  final CharacterTheme theme;

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LeaderboardCompetitorField(
          text: entry.rank,
          theme: theme,
        ),
        _LeaderboardCompetitorCharacter(
          characterAsset: entry.character,
          theme: theme,
        ),
        _LeaderboardCompetitorField(
          text: entry.playerInitials,
          theme: theme,
        ),
        _LeaderboardCompetitorField(
          text: entry.score.toString(),
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
    required this.characterAsset,
    required this.theme,
  }) : super(key: key);

  final CharacterTheme theme;
  final AssetGenImage characterAsset;

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
          child: characterAsset.image(),
        ),
      ),
    );
  }
}
