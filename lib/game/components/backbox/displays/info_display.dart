import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// Signature for the callback called when the used tries to share the score
/// on the [InfoDisplay].
typedef OnShareTap = void Function();

/// Signature for the callback called when the used tries to navigate to the
/// Google IO site on the [InfoDisplay].
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
    decorationThickness: 1,
  ),
);

final _descriptionTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.6,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

/// {@template info_display}
/// Display that handles shows to the user share or goto IO website.
/// {@endtemplate}
class InfoDisplay extends Component with HasGameRef {
  /// {@macro info_display}
  InfoDisplay({
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

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.overlays.add(PinballGame.replayButtonOverlay);
  }
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
      gameRef.images.fromCache(Assets.images.backbox.button.share.keyName),
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
            GotoIOLinkComponent(onTap: onNavigate),
          ],
        );
}

/// {@template share_link_component}
/// Link button for navigate to sharing score screen.
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
    text = readProvider<AppLocalizations>().share;
  }
}

/// {@template goto_io_link_component}
/// Link button for navigate to Google I/O site.
/// {@endtemplate}
class GotoIOLinkComponent extends TextComponent with HasGameRef, Tappable {
  /// {@macro goto_io_link_component}
  GotoIOLinkComponent({
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
            _LearnMore2TextComponent(),
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

class _LearnMore2TextComponent extends TextComponent with HasGameRef {
  _LearnMore2TextComponent()
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
