import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'skill_shot_state.dart';

class SkillShotCubit extends Cubit<SkillShotState> {
  SkillShotCubit() : super(const SkillShotState.initial());

  void onBallContacted() {
    emit(
      const SkillShotState(
        spriteState: SkillShotSpriteState.lit,
        isBlinking: true,
      ),
    );
  }

  void switched() {
    switch (state.spriteState) {
      case SkillShotSpriteState.lit:
        emit(state.copyWith(spriteState: SkillShotSpriteState.dimmed));
        break;
      case SkillShotSpriteState.dimmed:
        emit(state.copyWith(spriteState: SkillShotSpriteState.lit));
        break;
    }
  }

  void onBlinkingFinished() {
    emit(
      const SkillShotState(
        spriteState: SkillShotSpriteState.dimmed,
        isBlinking: false,
      ),
    );
  }
}
