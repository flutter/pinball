import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:share_repository/share_repository.dart';

/// Signature for the callback called when the user tries to share their score
/// from the [GameOverInfoDisplay].
typedef OnShareTap = void Function();

final _titleTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.6,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

final _titleBoldTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.4,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
    fontWeight: FontWeight.bold,
  ),
);

final _linkTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.7,
    color: PinballColors.orange,
    fontFamily: PinballFonts.pixeloidSans,
    fontWeight: FontWeight.bold,
  ),
);

final _descriptionTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.6,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

/// {@template game_over_info_display}
/// Display with links to share your score or go to the IO webpage.
/// {@endtemplate}
class GameOverInfoDisplay extends Component with HasGameRef {
  /// {@macro game_over_info_display}
  GameOverInfoDisplay({
    OnShareTap? onShare,
  }) : super(
          children: [
            _InstructionsComponent(
              onShare: onShare,
            ),
          ],
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.overlays.add(PinballGame.playButtonOverlay);
  }
}

class _InstructionsComponent extends PositionComponent with HasGameRef {
  _InstructionsComponent({
    OnShareTap? onShare,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(0, -25),
          children: [
            _TitleComponent(),
            _LinksComponent(
              onShare: onShare,
            ),
            _DescriptionComponent(),
          ],
        );
}

class _TitleComponent extends PositionComponent with HasGameRef {
  _TitleComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 3),
          children: [
            _TitleBackgroundSpriteComponent(),
            _ShareScoreTextComponent(),
            _ChallengeFriendsTextComponent(),
          ],
        );
}

class _ShareScoreTextComponent extends TextComponent with HasGameRef {
  _ShareScoreTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, -1.5),
          textRenderer: _titleTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = readProvider<AppLocalizations>().shareYourScore;
  }
}

class _ChallengeFriendsTextComponent extends TextComponent with HasGameRef {
  _ChallengeFriendsTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 1.5),
          textRenderer: _titleBoldTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = readProvider<AppLocalizations>().andChallengeYourFriends;
  }
}

class _TitleBackgroundSpriteComponent extends SpriteComponent with HasGameRef {
  _TitleBackgroundSpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2.zero(),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images
          .fromCache(Assets.images.backbox.displayTitleDecoration.keyName),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 22;
  }
}

class _LinksComponent extends PositionComponent with HasGameRef {
  _LinksComponent({
    OnShareTap? onShare,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(0, 9.2),
          children: [
            ShareLinkComponent(onTap: onShare),
            GoogleIOLinkComponent(),
          ],
        );
}

/// {@template share_link_component}
/// Link button to navigate to sharing score display.
/// {@endtemplate}
class ShareLinkComponent extends TextComponent with HasGameRef, Tappable {
  /// {@macro share_link_component}
  ShareLinkComponent({
    OnShareTap? onTap,
  })  : _onTap = onTap,
        super(
          anchor: Anchor.center,
          position: Vector2(-7, 0),
          textRenderer: _linkTextPaint,
        );

  final OnShareTap? _onTap;

  @override
  bool onTapDown(TapDownInfo info) {
    _onTap?.call();
    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      RectangleComponent(
        size: Vector2(6.4, 0.2),
        paint: Paint()..color = PinballColors.orange,
        anchor: Anchor.center,
        position: Vector2(3.2, 2.3),
      ),
    );

    text = readProvider<AppLocalizations>().share;
  }
}

/// {@template google_io_link_component}
/// Link button to navigate to Google I/O site.
/// {@endtemplate}
class GoogleIOLinkComponent extends TextComponent with HasGameRef, Tappable {
  /// {@macro google_io_link_component}
  GoogleIOLinkComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(6, 0),
          textRenderer: _linkTextPaint,
        );

  @override
  bool onTapUp(TapUpInfo info) {
    openLink(ShareRepository.googleIOEvent);
    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      RectangleComponent(
        size: Vector2(10.2, 0.2),
        paint: Paint()..color = PinballColors.orange,
        anchor: Anchor.center,
        position: Vector2(5.1, 2.3),
      ),
    );

    text = readProvider<AppLocalizations>().gotoIO;
  }
}

class _DescriptionComponent extends PositionComponent with HasGameRef {
  _DescriptionComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 13),
          children: [
            _LearnMoreTextComponent(),
            _FirebaseTextComponent(),
            OpenSourceTextComponent(),
          ],
        );
}

class _LearnMoreTextComponent extends TextComponent with HasGameRef {
  _LearnMoreTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2.zero(),
          textRenderer: _descriptionTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = readProvider<AppLocalizations>().learnMore;
  }
}

class _FirebaseTextComponent extends TextComponent with HasGameRef {
  _FirebaseTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-8.5, 2.5),
          textRenderer: _descriptionTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = readProvider<AppLocalizations>().firebaseOr;
  }
}

/// {@template open_source_link_component}
/// Link text to navigate to Open Source site.
/// {@endtemplate}
@visibleForTesting
class OpenSourceTextComponent extends TextComponent with HasGameRef, Tappable {
  /// {@macro open_source_link_component}
  OpenSourceTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(13.5, 2.5),
          textRenderer: _descriptionTextPaint,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    openLink(ShareRepository.openSourceCode);
    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(
      RectangleComponent(
        size: Vector2(16, 0.2),
        paint: Paint()..color = PinballColors.white,
        anchor: Anchor.center,
        position: Vector2(8, 2.3),
      ),
    );
    text = readProvider<AppLocalizations>().openSourceCode;
  }
}
