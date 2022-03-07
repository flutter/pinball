import 'package:equatable/equatable.dart';
import 'package:pinball_theme/pinball_theme.dart';

/// {@template pinball_theme}
/// Defines all theme assets and attributes.
///
/// Game components should have a getter specified here to load their
/// corresponding assets for the game.
/// {@endtemplate}
class PinballTheme extends Equatable {
  /// {@macro pinball_theme}
  const PinballTheme({
    required CharacterTheme characterTheme,
  }) : _characterTheme = characterTheme;

  final CharacterTheme _characterTheme;

  /// [CharacterTheme] for the chosen character.
  CharacterTheme get characterTheme => _characterTheme;

  @override
  List<Object?> get props => [_characterTheme];
}
