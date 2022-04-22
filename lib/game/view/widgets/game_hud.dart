// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/gen/gen.dart';

/// {@template game_hud}
/// Overlay of a [PinballGame] that displays the current [GameState.score],
/// [GameState.balls] and animation when the player get the bonus.
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
  static const _width = 265.0;

  @override
  Widget build(BuildContext context) {
    final isGameOver = context.select((GameBloc bloc) => bloc.state.isGameOver);

    return _ScoreViewDecoration(
      child: SizedBox(
        height: _width / _ratio,
        width: _width,
        child: BlocListener<GameBloc, GameState>(
          listenWhen: _listenWhen,
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

  bool _listenWhen(GameState previous, GameState current) {
    final previousCount = previous.bonusHistory.length;
    final currentCount = current.bonusHistory.length;
    return previousCount != currentCount;
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
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Assets.images.score.miniScoreBackground.path,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
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
      case GameBonus.dino:
        return BonusAnimation.dino(onCompleted: onComplete);
      case GameBonus.googleWord:
        return BonusAnimation.google(onCompleted: onComplete);
      case GameBonus.android:
        return BonusAnimation.android(onCompleted: onComplete);
    }
  }
}
