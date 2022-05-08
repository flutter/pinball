part of 'multiball_cubit.dart';

enum MultiballSpriteState {
  lit,
  dimmed,
}

class MultiballState extends Equatable {
  const MultiballState({
    required this.spriteState,
    required this.isAnimating,
  });

  const MultiballState.initial()
      : this(
          spriteState: MultiballSpriteState.dimmed,
          isAnimating: false,
        );

  final MultiballSpriteState spriteState;
  final bool isAnimating;

  MultiballState copyWith({
    MultiballSpriteState? lightState,
    bool? isAnimating,
  }) {
    return MultiballState(
      spriteState: lightState ?? this.spriteState,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }

  @override
  List<Object> get props => [spriteState, isAnimating];
}
