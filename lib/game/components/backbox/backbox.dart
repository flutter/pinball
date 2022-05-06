import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:pinball/game/components/backbox/bloc/backbox_bloc.dart';
import 'package:pinball/game/components/backbox/displays/displays.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_theme/pinball_theme.dart' hide Assets;
import 'package:platform_helper/platform_helper.dart';

/// {@template backbox}
/// The [Backbox] of the pinball machine.
/// {@endtemplate}
class Backbox extends PositionComponent with ZIndex, HasGameRef {
  /// {@macro backbox}
  Backbox({
    required LeaderboardRepository leaderboardRepository,
  })  : _bloc = BackboxBloc(leaderboardRepository: leaderboardRepository),
        _platformHelper = PlatformHelper();

  /// {@macro backbox}
  @visibleForTesting
  Backbox.test({
    required BackboxBloc bloc,
    required PlatformHelper platformHelper,
  })  : _bloc = bloc,
        _platformHelper = platformHelper;

  late final Component _display;
  final BackboxBloc _bloc;
  final PlatformHelper _platformHelper;
  late StreamSubscription<BackboxState> _subscription;

  @override
  Future<void> onLoad() async {
    position = Vector2(0, -87);
    anchor = Anchor.bottomCenter;
    zIndex = ZIndexes.backbox;

    _bloc.add(LeaderboardRequested());

    await add(_BackboxSpriteComponent());
    await add(_display = Component());
    _build(_bloc.state);

    _subscription = _bloc.stream.listen((state) {
      _display.children.removeWhere((_) => true);
      _build(state);
    });
  }

  @override
  void onRemove() {
    super.onRemove();
    _subscription.cancel();
  }

  void _build(BackboxState state) {
    if (state is LoadingState) {
      _display.add(LoadingDisplay());
    } else if (state is LeaderboardSuccessState) {
      _display.add(LeaderboardDisplay(entries: state.entries));
    } else if (state is InitialsFormState) {
      if (_platformHelper.isMobile) {
        gameRef.overlays.add(PinballGame.mobileControlsOverlay);
      }
      _display.add(
        InitialsInputDisplay(
          score: state.score,
          characterIconPath: state.character.leaderboardIcon.keyName,
          onSubmit: (initials) {
            _bloc.add(
              PlayerInitialsSubmitted(
                score: state.score,
                initials: initials,
                character: state.character,
              ),
            );
          },
        ),
      );
    } else if (state is InitialsSuccessState) {
      _display.add(InitialsSubmissionSuccessDisplay());
    } else if (state is InitialsFailureState) {
      _display.add(InitialsSubmissionFailureDisplay());
    }
  }

  /// Puts [InitialsInputDisplay] on the [Backbox].
  void requestInitials({
    required int score,
    required CharacterTheme character,
  }) {
    _bloc.add(
      PlayerInitialsRequested(
        score: score,
        character: character,
      ),
    );
  }
}

class _BackboxSpriteComponent extends SpriteComponent with HasGameRef {
  _BackboxSpriteComponent() : super(anchor: Anchor.bottomCenter);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = Sprite(
      gameRef.images.fromCache(
        Assets.images.backbox.marquee.keyName,
      ),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 20;
  }
}
