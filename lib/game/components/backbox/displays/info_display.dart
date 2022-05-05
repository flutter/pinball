import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pinball/game/game.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_ui/pinball_ui.dart';

/// Signature for the callback called when the used has
/// shared score on the [InfoDisplay].
typedef ScoreOnShared = void Function(String);

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
    decoration: TextDecoration.underline,
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
/// Display that handles the user input on the game over view.
/// {@endtemplate}
class InfoDisplay extends Component with HasGameRef {
  /// {@macro info_display}
  InfoDisplay({
    required int score,
    required String characterIconPath,
    ScoreOnShared? onShared,
  })  : _onShared = onShared,
        super(
          children: [
            _InstructionsComponent(),
          ],
        );

  final ScoreOnShared? _onShared;

  bool _share() {
    _onShared?.call('');
    return true;
  }
}

class _InstructionsComponent extends PositionComponent with HasGameRef {
  _InstructionsComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, -25),
          children: [
            _TitleComponent(),
            _LinksComponent(),
            _DescriptionComponent(),
          ],
        );
}

class _TitleComponent extends PositionComponent with HasGameRef<PinballGame> {
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

class _ShareScoreTextComponent extends TextComponent
    with HasGameRef<PinballGame> {
  _ShareScoreTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, -1.5),
          textRenderer: _titleTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = 'Share your score';
    //gameRef.l10n.shareYourScore;
  }
}

class _ChallengeFriendsTextComponent extends TextComponent
    with HasGameRef<PinballGame> {
  _ChallengeFriendsTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 1.5),
          textRenderer: _titleBoldTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = 'AND CHALLENGE YOUR FRIENDS';
    //gameRef.l10n.challengeYourFriends;
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

class _LinksComponent extends PositionComponent with HasGameRef<PinballGame> {
  _LinksComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 9.2),
          children: [
            _ShareLinkComponent(),
            _GotoIOLinkComponent(),
          ],
        );
}

class _ShareLinkComponent extends TextComponent with HasGameRef<PinballGame> {
  _ShareLinkComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(-7, 0),
          textRenderer: _linkTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = 'SHARE'; //gameRef.l10n.share;
  }
}

class _GotoIOLinkComponent extends TextComponent with HasGameRef<PinballGame> {
  _GotoIOLinkComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(6, 0),
          textRenderer: _linkTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = 'GO TO I/O'; //gameRef.l10n.gotoIO;
  }
}

class _DescriptionComponent extends PositionComponent
    with HasGameRef<PinballGame> {
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

class _LearnMoreTextComponent extends TextComponent
    with HasGameRef<PinballGame> {
  _LearnMoreTextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2.zero(),
          textRenderer: _descriptionTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = 'Learn more about building games in Flutter with';
    //gameRef.l10n.learnMore;
  }
}

class _LearnMore2TextComponent extends TextComponent
    with HasGameRef<PinballGame> {
  _LearnMore2TextComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, 2.5),
          textRenderer: _descriptionTextPaint,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    text = 'Firebase or dive right into the open source code.';
    //gameRef.l10n.learnMore2;
  }
}
