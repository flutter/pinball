import 'package:pinball_theme/pinball_theme.dart';

/// {@template dash_theme}
/// Defines Dash character theme assets and attributes.
/// {@endtemplate}
class DashTheme extends CharacterTheme {
  /// {@macro dash_theme}
  const DashTheme();

  @override
  String get name => 'Dash';

  @override
  AssetGenImage get ball => Assets.images.dash.ball;

  @override
  AssetGenImage get background => Assets.images.dash.background;

  @override
  AssetGenImage get icon => Assets.images.dash.icon;

  @override
  AssetGenImage get leaderboardIcon => Assets.images.dash.leaderboardIcon;

  @override
  AssetGenImage get animation => Assets.images.dash.animation;
}
