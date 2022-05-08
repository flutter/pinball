import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pinball/l10n/l10n.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_flame/pinball_flame.dart';
import 'package:pinball_ui/pinball_ui.dart';
import 'package:share_repository/share_repository.dart';

/// Signature for the callback called when the user tries to share their score
/// on the [ShareDisplay].
typedef OnSocialShareTap = void Function(SharePlatform);

final _descriptionTextPaint = TextPaint(
  style: const TextStyle(
    fontSize: 1.6,
    color: PinballColors.white,
    fontFamily: PinballFonts.pixeloidSans,
  ),
);

/// {@template share_display}
/// Display that allows users to share their score to social networks.
/// {@endtemplate}
class ShareDisplay extends Component with HasGameRef {
  /// {@macro share_display}
  ShareDisplay({
    OnSocialShareTap? onShare,
  }) : super(
          children: [
            _ShareInstructionsComponent(
              onShare: onShare,
            ),
          ],
        );
}

class _ShareInstructionsComponent extends PositionComponent with HasGameRef {
  _ShareInstructionsComponent({
    OnSocialShareTap? onShare,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(0, -25),
          children: [
            _DescriptionComponent(),
            _SocialNetworksComponent(
              onShare: onShare,
            ),
          ],
        );
}

class _DescriptionComponent extends PositionComponent with HasGameRef {
  _DescriptionComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2.zero(),
          children: [
            _LetEveryoneTextComponent(),
            _SharingYourScoreTextComponent(),
            _SocialMediaTextComponent(),
          ],
        );
}

class _LetEveryoneTextComponent extends TextComponent with HasGameRef {
  _LetEveryoneTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2.zero(),
          textRenderer: _descriptionTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = readProvider<AppLocalizations>().letEveryone;
  }
}

class _SharingYourScoreTextComponent extends TextComponent with HasGameRef {
  _SharingYourScoreTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 2.5),
          textRenderer: _descriptionTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = readProvider<AppLocalizations>().bySharingYourScore;
  }
}

class _SocialMediaTextComponent extends TextComponent with HasGameRef {
  _SocialMediaTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 5),
          textRenderer: _descriptionTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = readProvider<AppLocalizations>().socialMediaAccount;
  }
}

class _SocialNetworksComponent extends PositionComponent with HasGameRef {
  _SocialNetworksComponent({
    OnSocialShareTap? onShare,
  }) : super(
          anchor: Anchor.center,
          position: Vector2(0, 12),
          children: [
            FacebookButtonComponent(onTap: onShare),
            TwitterButtonComponent(onTap: onShare),
          ],
        );
}

/// {@template facebook_button_component}
/// Button for sharing on Facebook.
/// {@endtemplate}
class FacebookButtonComponent extends SpriteComponent
    with HasGameRef, Tappable {
  /// {@macro facebook_button_component}
  FacebookButtonComponent({
    OnSocialShareTap? onTap,
  })  : _onTap = onTap,
        super(
          anchor: Anchor.center,
          position: Vector2(-5, 0),
        );

  final OnSocialShareTap? _onTap;

  @override
  bool onTapDown(TapDownInfo info) {
    _onTap?.call(SharePlatform.facebook);
    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(Assets.images.backbox.button.facebook.keyName),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 25;
  }
}

/// {@template twitter_button_component}
/// Button for sharing on Twitter.
/// {@endtemplate}
class TwitterButtonComponent extends SpriteComponent with HasGameRef, Tappable {
  /// {@macro twitter_button_component}
  TwitterButtonComponent({
    OnSocialShareTap? onTap,
  })  : _onTap = onTap,
        super(
          anchor: Anchor.center,
          position: Vector2(5, 0),
        );

  final OnSocialShareTap? _onTap;

  @override
  bool onTapDown(TapDownInfo info) {
    _onTap?.call(SharePlatform.twitter);
    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final sprite = Sprite(
      gameRef.images.fromCache(Assets.images.backbox.button.twitter.keyName),
    );
    this.sprite = sprite;
    size = sprite.originalSize / 25;
  }
}
