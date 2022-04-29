// ignore_for_file: public_member_api_docs

part of 'multiplier_cubit.dart';

enum MultiplierSpriteState {
  lit,
  dimmed,
}

class MultiplierState extends Equatable {
  const MultiplierState({
    required this.value,
    required this.spriteState,
  });

  const MultiplierState.initial(MultiplierValue multiplierValue)
      : this(
          value: multiplierValue,
          spriteState: MultiplierSpriteState.dimmed,
        );

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
