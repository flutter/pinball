import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/gen.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// {@template game_hud}
/// Overlay on the [PinballGame].
///
/// Displays the current [GameState.displayScore], [GameState.rounds] and
/// animates when the player gets a [GameBonus].
/// {@endtemplate}
class GameHud extends StatefulWidget {
  /// {@macro game_hud}
  const GameHud({Key? key}) : super(key: key);

  @override
  State<GameHud> createState() => _GameHudState();
}

class _GameHudState extends State<GameHud> {
  bool showAnimation = false;

  /// Ratio from sprite frame (width 500, height 144) w / h = ratio
  static const _ratio = 3.47;

  @override
  Widget build(BuildContext context) {
    final isGameOver =
        context.select((GameBloc bloc) => bloc.state.status.isGameOver);

    final height = _calculateHeight(context);

    return _ScoreViewDecoration(
      child: SizedBox(
        height: height,
        width: height * _ratio,
        child: BlocListener<GameBloc, GameState>(
          listenWhen: (previous, current) =>
              previous.bonusHistory.length != current.bonusHistory.length,
          listener: (_, __) => setState(() => showAnimation = true),
          child: AnimatedSwitcher(
            duration: kThemeAnimationDuration,
            child: showAnimation && !isGameOver
                ? _AnimationView(
                    onComplete: () {
                      if (mounted) {
                        setState(() => showAnimation = false);
                      }
                    },
                  )
                : const ScoreView(),
          ),
        ),
      ),
    );
  }

  double _calculateHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.09;
    if (height > 90) {
      return 90;
    } else if (height < 60) {
      return 60;
    } else {
      return height;
    }
  }
}

class _ScoreViewDecoration extends StatelessWidget {
  const _ScoreViewDecoration({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(12));
    const borderWidth = 5.0;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        border: Border.all(
          color: PinballColors.white,
          width: borderWidth,
        ),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            Assets.images.score.miniScoreBackground.path,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(borderWidth - 1),
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ),
      ),
    );
  }
}

class _AnimationView extends StatelessWidget {
  const _AnimationView({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final lastBonus = context.select(
      (GameBloc bloc) => bloc.state.bonusHistory.last,
    );
    switch (lastBonus) {
      case GameBonus.dashNest:
        return BonusAnimation.dashNest(onCompleted: onComplete);
      case GameBonus.sparkyTurboCharge:
        return BonusAnimation.sparkyTurboCharge(onCompleted: onComplete);
      case GameBonus.dinoChomp:
        return BonusAnimation.dinoChomp(onCompleted: onComplete);
      case GameBonus.googleWord:
        return BonusAnimation.googleWord(onCompleted: onComplete);
      case GameBonus.androidSpaceship:
        return BonusAnimation.androidSpaceship(onCompleted: onComplete);
    }
  }
}
