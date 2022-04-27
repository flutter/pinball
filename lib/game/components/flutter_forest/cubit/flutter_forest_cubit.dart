import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pinball_components/pinball_components.dart';

part 'flutter_forest_state.dart';

// TODO(alestiago): Evaluate if there is any useful documentation that could
// be added to this class.
// ignore: public_member_api_docs
class FlutterForestCubit extends Cubit<FlutterForestState> {
  // ignore: public_member_api_docs
  FlutterForestCubit() : super(const FlutterForestState.initial());

  /// Event added when a bumper contacts with a ball.
  void onBumperActivated(DashNestBumper dashNestBumper) {
    emit(
      state.copyWith(
        activatedBumpers: state.activatedBumpers.union({dashNestBumper}),
      ),
    );
  }

  /// Event added after the bonus is activated.
  void onBonusApplied() {
    emit(
      state.copyWith(activatedBumpers: const {}),
    );
  }
}
