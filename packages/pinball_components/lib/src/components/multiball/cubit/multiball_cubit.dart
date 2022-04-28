// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';

part 'multiball_state.dart';

class MultiballCubit extends Cubit<MultiballState> {
  MultiballCubit() : super(MultiballState.dimmed);

  void animate() {
    emit(MultiballState.lit);
  }

  void onBlinked() {
    emit(MultiballState.dimmed);
  }
}
