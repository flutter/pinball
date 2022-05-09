part of 'plunger_cubit.dart';

enum PlungerState {
  pulling,

  releasing,
}

extension PlungerStateX on PlungerState {
  bool get isPulling => this == PlungerState.pulling;
  bool get isReleasing => this == PlungerState.releasing;
}
