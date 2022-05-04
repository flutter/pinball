// ignore_for_file: public_member_api_docs

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

  void onBlinkedOff() {
    emit(state.copyWith(spriteState: SkillShotSpriteState.lit));
  }

  void onBlinkedOn() {
    emit(state.copyWith(spriteState: SkillShotSpriteState.dimmed));
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
