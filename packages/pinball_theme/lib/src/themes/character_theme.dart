import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template character_theme}
/// Base class for creating character themes.
///
/// Character specific game components should have a getter specified here to
/// load their corresponding assets for the game.
/// {@endtemplate}
abstract class CharacterTheme extends Equatable {
  /// {@macro character_theme}
  const CharacterTheme();

  /// Ball color for this theme.
  Color get ballColor;

  @override
  List<Object?> get props => [ballColor];
}
