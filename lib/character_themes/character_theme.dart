import 'package:equatable/equatable.dart';
import 'package:flame/palette.dart';

/// {@template character_theme}
/// Template for creating character themes.
///
/// Any character specific game pieces should have a getter specified here so
/// their corresponding assets can be retrieved for the game.
/// {@endtemplate}
abstract class CharacterTheme extends Equatable {
  /// {@macro character_theme}
  const CharacterTheme();

  Color get ballColor;

  @override
  List<Object?> get props => [];
}
