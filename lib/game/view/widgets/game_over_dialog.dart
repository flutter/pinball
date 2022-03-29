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

  /// Score achieved by the current user.
  final int score;

  /// Theme of the current user.
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

/// {@template game_over_dialog_view}
/// View for showing final score when the game is finished.
/// {@endtemplate}
@visibleForTesting
class GameOverDialogView extends StatefulWidget {
  /// {@macro game_over_dialog_view}
  const GameOverDialogView({
    Key? key,
    required this.score,
    required this.theme,
  }) : super(key: key);

  /// Score achieved by the current user.
  final int score;

  /// Theme of the current user.
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
    final l10n = context.l10n;

    // TODO(ruimiguel): refactor this view once UI design finished.
    return Dialog(
      child: SizedBox(
        width: 200,
        height: 250,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.gameOver,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${l10n.yourScore} ${widget.score}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    key: const Key('player_initials_text_field'),
                    controller: playerInitialsInputController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: l10n.enterInitials,
                    ),
                    maxLength: 3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _GameOverDialogActions(
                    score: widget.score,
                    theme: widget.theme,
                    playerInitialsInputController:
                        playerInitialsInputController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GameOverDialogActions extends StatelessWidget {
  const _GameOverDialogActions({
    Key? key,
    required this.score,
    required this.theme,
    required this.playerInitialsInputController,
  }) : super(key: key);

  final int score;
  final CharacterTheme theme;
  final TextEditingController playerInitialsInputController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<LeaderboardBloc, LeaderboardState>(
      builder: (context, state) {
        switch (state.status) {
          case LeaderboardStatus.loading:
            return TextButton(
              onPressed: () {
                context.read<LeaderboardBloc>().add(
                      LeaderboardEntryAdded(
                        entry: LeaderboardEntryData(
                          playerInitials:
                              playerInitialsInputController.text.toUpperCase(),
                          score: score,
                          character: theme.toType,
                        ),
                      ),
                    );
              },
              child: Text(l10n.addUser),
            );
          case LeaderboardStatus.success:
            return TextButton(
              onPressed: () => Navigator.of(context).push<void>(
                LeaderboardPage.route(theme: theme),
              ),
              child: Text(l10n.leaderboard),
            );
          case LeaderboardStatus.error:
            return Text(l10n.error);
        }
      },
    );
  }
}
