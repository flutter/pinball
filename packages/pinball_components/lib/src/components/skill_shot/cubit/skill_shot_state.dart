part of 'skill_shot_cubit.dart';

enum SkillShotSpriteState {
  lit,
  dimmed,
}

class SkillShotState extends Equatable {
  const SkillShotState({
    required this.spriteState,
    required this.isBlinking,
  });

  const SkillShotState.initial()
      : this(
          spriteState: SkillShotSpriteState.dimmed,
          isBlinking: false,
        );

  final SkillShotSpriteState spriteState;

  final bool isBlinking;

  SkillShotState copyWith({
    SkillShotSpriteState? spriteState,
    bool? isBlinking,
  }) =>
      SkillShotState(
        spriteState: spriteState ?? this.spriteState,
        isBlinking: isBlinking ?? this.isBlinking,
      );

  @override
  List<Object?> get props => [spriteState, isBlinking];
}
