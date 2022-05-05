import 'package:pinball_theme/pinball_theme.dart';

/// {@template sparky_theme}
/// Defines Sparky character theme assets and attributes.
/// {@endtemplate}
class SparkyTheme extends CharacterTheme {
  /// {@macro sparky_theme}
  const SparkyTheme();

  @override
  AssetGenImage get ball => Assets.images.sparky.ball;

  @override
  String get name => 'Sparky';

  @override
  AssetGenImage get background => Assets.images.sparky.background;

  @override
  AssetGenImage get icon => Assets.images.sparky.icon;

  @override
  AssetGenImage get leaderboardIcon => Assets.images.sparky.leaderboardIcon;

  @override
  AssetGenImage get animation => Assets.images.sparky.animation;
}
