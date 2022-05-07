import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// Signature for the callback called when the user tries to share their score
/// from the [GameOverInfoDisplay].
typedef OnShareTap = void Function();

/// Signature for the callback called when the user tries to navigate to the
/// Google IO site from the [GameOverInfoDisplay].
typedef OnNavigateTap = void Function();

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
    OnNavigateTap? onNavigate,
  }) : super(
          children: [
            _InstructionsComponent(
              onShare: onShare,
              onNavigate: onNavigate,
            ),
          ],
        );
}

class _InstructionsComponent extends PositionComponent with HasGameRef {
  _InstructionsComponent({
    OnShareTap? onShare,
    OnNavigateTap? onNavigate,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(0, -25),
          children: [
            _TitleComponent(),
            _LinksComponent(
              onShare: onShare,
              onNavigate: onNavigate,
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
    OnNavigateTap? onNavigate,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(0, 9.2),
          children: [
            ShareLinkComponent(onTap: onShare),
            GoogleIOLinkComponent(onTap: onNavigate),
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
  GoogleIOLinkComponent({
    OnNavigateTap? onTap,
  })  : _onTap = onTap,
        super(
          anchor: Anchor.center,
          position: Vector2(6, 0),
          textRenderer: _linkTextPaint,
        );

  final OnNavigateTap? _onTap;

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
            _FirebaseOrOpenSourceTextComponent(),
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

class _FirebaseOrOpenSourceTextComponent extends TextComponent with HasGameRef {
  _FirebaseOrOpenSourceTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 2.5),
          textRenderer: _descriptionTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = readProvider<AppLocalizations>().firebaseOrOpenSource;
  }
}
