// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spaceship_ramp_state.dart';

class SpaceshipRampCubit extends Cubit<SpaceshipRampState> {
  SpaceshipRampCubit() : super(SpaceshipRampState.initial());

  void onInside() {
    emit(
      state.copyWith(
        hits: state.hits + 1,
      ),
    );
  }
}
