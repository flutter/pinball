// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball/leaderboard/leaderboard.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template game_over_dialog}
/// [Dialog] displayed when the [PinballGame] is over.
/// {@endtemplate}
class GameOverDialog extends StatelessWidget {
  /// {@macro game_over_dialog}
  const GameOverDialog({Key? key, required this.score, required this.theme})
      : super(key: key);

  final int score;
  final CharacterTheme theme;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        context.read<LeaderboardRepository>(),
      ),
      child: GameOverDialogView(score: score, theme: theme),
    );
  }
}

class GameOverDialogView extends StatefulWidget {
  const GameOverDialogView({Key? key, required this.score, required this.theme})
      : super(key: key);

  final int score;
  final CharacterTheme theme;

  @override
  State<GameOverDialogView> createState() => _GameOverDialogViewState();
}

class _GameOverDialogViewState extends State<GameOverDialogView> {
  final playerInitialsInputController = TextEditingController();

  @override
  void dispose() {
    playerInitialsInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 200,
        height: 250,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Game Over',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Your score is ${widget.score}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: playerInitialsInputController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your initials',
                  ),
                  maxLength: 3,
                ),
                const SizedBox(
                  height: 10,
                ),
                // TODO(ruimiguel): refactor this view once UI design finished.
                BlocBuilder<LeaderboardBloc, LeaderboardState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case LeaderboardStatus.loading:
                        return TextButton(
                          onPressed: () {
                            context.read<LeaderboardBloc>().add(
                                  LeaderboardEntryAdded(
                                    entry: LeaderboardEntryData(
                                      playerInitials:
                                          playerInitialsInputController.text
                                              .toUpperCase(),
                                      score: widget.score,
                                      character: widget.theme.toType,
                                    ),
                                  ),
                                );
                          },
                          child: const Text('Add User'),
                        );
                      case LeaderboardStatus.success:
                        return TextButton(
                          onPressed: () => Navigator.of(context).push<void>(
                            LeaderboardPage.route(theme: widget.theme),
                          ),
                          child: Text(l10n.leaderboard),
                        );
                      case LeaderboardStatus.error:
                        return const Text('error');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
