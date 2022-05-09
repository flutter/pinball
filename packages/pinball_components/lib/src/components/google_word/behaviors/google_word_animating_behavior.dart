import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:pinball_components/pinball_components.dart';

class GoogleWordAnimatingBehavior extends TimerComponent
    with FlameBlocReader<GoogleWordCubit, GoogleWordState> {
  GoogleWordAnimatingBehavior() : super(period: 0.35, repeat: true);

  final _maxBlinks = 7;
  int _blinks = 0;

  @override
  void onTick() {
    super.onTick();
    if (_blinks != _maxBlinks * 2) {
      bloc.switched();
      _blinks++;
    } else {
      timer.stop();
      bloc.onAnimationFinished();
      shouldRemove = true;
    }
  }
}
