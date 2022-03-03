import 'package:equatable/equatable.dart';
import 'package:flame/palette.dart';

/// {@template character_theme}
/// Template for creating character themes.
/// {@endtemplate}
abstract class CharacterTheme extends Equatable {
  /// {@macro character_theme}
  const CharacterTheme();

  Color get ballColor;

  @override
  List<Object?> get props => [];
}
