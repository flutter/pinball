import 'package:bloc/bloc.dart';

part 'flipper_state.dart';

class FlipperCubit extends Cubit<FlipperState> {
  FlipperCubit() : super(FlipperState.movingDown);

  void moveUp() => emit(FlipperState.movingUp);

  void moveDown() => emit(FlipperState.movingDown);
}
