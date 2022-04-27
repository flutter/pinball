import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'flutter_forest_state.dart';

class FlutterForestCubit extends Cubit<FlutterForestState> {
  FlutterForestCubit() : super(FlutterForestState.initial());

  void onBumperActivated(DashNestBumper dashNestBumper) {
    emit(
      state.copyWith(
        activatedBumpers: state.activatedBumpers.union({dashNestBumper}),
      ),
    );
  }

  void onBonusApplied() {
    emit(
      state.copyWith(activatedBumpers: const {}),
    );
  }
}
