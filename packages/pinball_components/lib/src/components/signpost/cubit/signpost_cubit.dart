import 'package:bloc/bloc.dart';

part 'signpost_state.dart';

class SignpostCubit extends Cubit<SignpostState> {
  SignpostCubit() : super(SignpostState.inactive);

  void onProgressed() {
    final index = SignpostState.values.indexOf(state);
    emit(
      SignpostState.values[(index + 1) % SignpostState.values.length],
    );
  }

  void onReset() => emit(SignpostState.inactive);

  bool isFullyProgressed() => state == SignpostState.active3;
}
