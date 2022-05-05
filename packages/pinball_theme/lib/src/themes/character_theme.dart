import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template character_theme}
/// Base class for creating character themes.
///
/// Character specific game components should have a getter specified here to
/// load their corresponding assets for the game.
/// {@endtemplate}
abstract class CharacterTheme extends Equatable {
  /// {@macro character_theme}
  const CharacterTheme();

  /// Name of character.
  String get name;

  /// Asset for the ball.
  AssetGenImage get ball;

  /// Asset for the background.
  AssetGenImage get background;

  /// Icon asset.
  AssetGenImage get icon;

  /// Icon asset for the leaderboard.
  AssetGenImage get leaderboardIcon;

  /// Asset for the the idle character animation.
  AssetGenImage get animation;

  @override
  List<Object?> get props => [
        name,
        ball,
        background,
        icon,
        leaderboardIcon,
        animation,
      ];
}
