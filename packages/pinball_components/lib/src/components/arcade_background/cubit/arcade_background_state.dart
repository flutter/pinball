// ignore_for_file: public_member_api_docs

part of 'arcade_background_cubit.dart';

class ArcadeBackgroundState extends Equatable {
  const ArcadeBackgroundState({required this.characterTheme});

  const ArcadeBackgroundState.initial()
      : this(characterTheme: const DashTheme());

  final CharacterTheme characterTheme;

  @override
  List<Object> get props => [characterTheme];
}
