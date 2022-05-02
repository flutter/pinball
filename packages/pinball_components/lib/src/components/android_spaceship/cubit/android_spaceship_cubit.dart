// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'android_spaceship_state.dart';

class AndroidSpaceshipCubit extends Cubit<AndroidSpaceshipState> {
  AndroidSpaceshipCubit() : super(AndroidSpaceshipState.idle);

  void onEntered() => emit(AndroidSpaceshipState.activated);

  void onBonusAwarded() => emit(AndroidSpaceshipState.idle);
}
