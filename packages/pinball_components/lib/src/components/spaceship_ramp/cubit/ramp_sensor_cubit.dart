// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:pinball_components/pinball_components.dart';

part 'ramp_sensor_state.dart';

class RampSensorCubit extends Cubit<RampSensorState> {
  RampSensorCubit() : super(const RampSensorState.initial());

  void onDoor(Ball ball) {
    emit(
      state.copyWith(
        type: RampSensorType.door,
        ball: ball,
      ),
    );
  }

  void onInside(Ball ball) {
    emit(
      state.copyWith(
        type: RampSensorType.inside,
        ball: ball,
      ),
    );
  }
}
