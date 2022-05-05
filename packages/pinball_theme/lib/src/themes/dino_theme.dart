import 'package:pinball_theme/pinball_theme.dart';

/// {@template dino_theme}
/// Defines Dino character theme assets and attributes.
/// {@endtemplate}
class DinoTheme extends CharacterTheme {
  /// {@macro dino_theme}
  const DinoTheme();

  @override
  String get name => 'Dino';

  @override
  AssetGenImage get ball => Assets.images.dino.ball;

  @override
  AssetGenImage get background => Assets.images.dino.background;

  @override
  AssetGenImage get icon => Assets.images.dino.icon;

  @override
  AssetGenImage get leaderboardIcon => Assets.images.dino.leaderboardIcon;

  @override
  AssetGenImage get animation => Assets.images.dino.animation;
}
