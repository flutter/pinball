import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'android_ramp_sensor_state.dart';

class AndroidRampSensorCubit extends Cubit<AndroidRampSensorState> {
  AndroidRampSensorCubit() : super(AndroidRampSensorState.initial());

  void onDoor(Ball ball) {
    emit(
      state.copyWith(
        type: AndroidRampSensorType.door,
        ball: ball,
      ),
    );
  }

  void onInside(Ball ball) {
    emit(
      state.copyWith(
        type: AndroidRampSensorType.inside,
        ball: ball,
      ),
    );
  }
}
