// ignore_for_file: comment_references, public_member_api_docs

part of 'multiball_cubit.dart';

/// Indicates the different sprite states for [MultiballSpriteGroupComponent].
enum MultiballLightState {
  lit,
  dimmed,
}

// Indicates if the blinking animation is running.
enum MultiballAnimationState {
  stopped,
  animated,
}

class MultiballState extends Equatable {
  const MultiballState({
    required this.lightState,
    required this.animationState,
  });

  const MultiballState.initial()
      : this(
          lightState: MultiballLightState.dimmed,
          animationState: MultiballAnimationState.stopped,
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
