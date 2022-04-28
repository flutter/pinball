// ignore_for_file: public_member_api_docs

part of 'multiplier_cubit.dart';

/// Indicates the different sprite states for [MultiplierSpriteGroupComponent].
enum MultiplierSpriteState {
  lit,
  dimmed,
}

/// Indicates the [MultiplierCubit]'s current state.
class MultiplierState extends Equatable {
  const MultiplierState({
    required this.value,
    required this.spriteState,
  });

  /// Current value for the [Multiplier]
  final MultiplierValue value;

  /// The [MultiplierSpriteGroupComponent] current sprite state
  final MultiplierSpriteState spriteState;

  MultiplierState copyWith({
    MultiplierSpriteState? spriteState,
  }) {
    return MultiplierState(
      value: value,
      spriteState: spriteState ?? this.spriteState,
    );
  }

  @override
  List<Object> get props => [value, spriteState];
}
