// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'android_spaceship_state.dart';

class AndroidSpaceshipCubit extends Cubit<AndroidSpaceshipState> {
  AndroidSpaceshipCubit() : super(AndroidSpaceshipState.withoutBonus);

  void onBallEntered() => emit(AndroidSpaceshipState.withBonus);

  void onBonusAwarded() => emit(AndroidSpaceshipState.withoutBonus);
}
