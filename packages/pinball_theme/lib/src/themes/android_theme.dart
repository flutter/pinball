import 'package:pinball_theme/pinball_theme.dart';

/// {@template android_theme}
/// Defines Android character theme assets and attributes.
/// {@endtemplate}
class AndroidTheme extends CharacterTheme {
  /// {@macro android_theme}
  const AndroidTheme();

  @override
  String get name => 'Android';

  @override
  AssetGenImage get ball => Assets.images.android.ball;

  @override
  AssetGenImage get background => Assets.images.android.background;

  @override
  AssetGenImage get icon => Assets.images.android.icon;

  @override
  AssetGenImage get leaderboardIcon => Assets.images.android.leaderboardIcon;

  @override
  AssetGenImage get animation => Assets.images.android.animation;
}
