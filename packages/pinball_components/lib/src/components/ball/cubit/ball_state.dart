// ignore_for_file: public_member_api_docs

part of 'ball_cubit.dart';

class BallState extends Equatable {
  const BallState({required this.characterTheme});

  const BallState.initial() : this(characterTheme: const DashTheme());

  final CharacterTheme characterTheme;

  @override
  List<Object> get props => [characterTheme];
}
