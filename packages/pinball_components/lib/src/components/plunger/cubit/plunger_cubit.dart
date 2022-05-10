import 'package:bloc/bloc.dart';

part 'plunger_state.dart';

class PlungerCubit extends Cubit<PlungerState> {
  PlungerCubit() : super(PlungerState.releasing);

  void pulled() => emit(PlungerState.pulling);

  void released() => emit(PlungerState.releasing);

  void autoPulled() => emit(PlungerState.autoPulling);
}
