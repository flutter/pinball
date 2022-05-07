part of 'multiball_cubit.dart';

enum MultiballLightState {
  lit,
  dimmed,
}

// Indicates if the blinking animation is running.
enum MultiballAnimationState {
  idle,
  blinking,
}

class MultiballState extends Equatable {
  const MultiballState({
    required this.lightState,
    required this.animationState,
  });

  const MultiballState.initial()
      : this(
          lightState: MultiballLightState.dimmed,
          animationState: MultiballAnimationState.idle,
        );

  final MultiballLightState lightState;
  final MultiballAnimationState animationState;

  MultiballState copyWith({
    MultiballLightState? lightState,
    MultiballAnimationState? animationState,
  }) {
    return MultiballState(
      lightState: lightState ?? this.lightState,
      animationState: animationState ?? this.animationState,
    );
  }

  @override
  List<Object> get props => [lightState, animationState];
}
