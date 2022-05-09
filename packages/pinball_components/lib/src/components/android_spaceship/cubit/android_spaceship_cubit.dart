import 'package:bloc/bloc.dart';

part 'android_spaceship_state.dart';

class AndroidSpaceshipCubit extends Cubit<AndroidSpaceshipState> {
  AndroidSpaceshipCubit() : super(AndroidSpaceshipState.withoutBonus);

  void onBallContacted() => emit(AndroidSpaceshipState.withBonus);

  void onBonusAwarded() => emit(AndroidSpaceshipState.withoutBonus);
}
