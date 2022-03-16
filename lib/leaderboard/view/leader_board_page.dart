// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/theme/theme.dart';
import 'package:pinball_theme/pinball_theme.dart';

class LeaderBoardPage extends StatelessWidget {
  const LeaderBoardPage({Key? key, required this.theme}) : super(key: key);

  final PinballTheme theme;

  static Route route(PinballTheme theme) {
    return MaterialPageRoute<void>(
      builder: (_) => LeaderBoardPage(theme: theme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ThemeCubit()..characterSelected(theme.characterTheme),
      child: const LeaderBoardView(),
    );
  }
}

class LeaderBoardView extends StatelessWidget {
  const LeaderBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Text(
              l10n.leadersBoard,
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(height: 80),
            const _LeaderBoardView(),
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
    );
  }
}

class _LeaderBoardView extends StatelessWidget {
  const _LeaderBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _LeaderBoardHeaders(),
            _LeaderBoardList(),
          ],
        ),
      ),
    );
  }
}

class _LeaderBoardHeaders extends StatelessWidget {
  const _LeaderBoardHeaders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LeaderBoardHeaderItem(title: l10n.rank),
        _LeaderBoardHeaderItem(title: l10n.character),
        _LeaderBoardHeaderItem(title: l10n.userName),
        _LeaderBoardHeaderItem(title: l10n.score),
      ],
    );
  }
}

class _LeaderBoardHeaderItem extends StatelessWidget {
  const _LeaderBoardHeaderItem({Key? key, required this.title})
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

class _LeaderBoardList extends StatelessWidget {
  const _LeaderBoardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (_, index) => _LeaderBoardCompetitor(
        competitor: Competitor(
          rank: index,
          characterTheme: const SparkyTheme(),
          userName: 'user$index',
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
        _LeaderBoardCompetitorField(text: competitor.rank.toString()),
        _LeaderBoardCompetitorCharacter(
          characterTheme: competitor.characterTheme,
        ),
        _LeaderBoardCompetitorField(text: competitor.userName),
        _LeaderBoardCompetitorField(text: competitor.score.toString()),
      ],
    );
  }
}

class _LeaderBoardCompetitorField extends StatelessWidget {
  const _LeaderBoardCompetitorField({Key? key, required this.text})
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

class _LeaderBoardCompetitorCharacter extends StatelessWidget {
  const _LeaderBoardCompetitorCharacter({
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

class Competitor {
  Competitor({
    required this.rank,
    required this.characterTheme,
    required this.userName,
    required this.score,
  });

  final int rank;
  final CharacterTheme characterTheme;
  final String userName;
  final int score;
}
