part of 'dash_bumpers_cubit.dart';

class DashBumpersState extends Equatable {
  const DashBumpersState({required this.bumperSpriteStates});

  DashBumpersState.initial()
      : this(
          bumperSpriteStates: {
            for (var id in DashBumperId.values)
              id: DashBumperSpriteState.inactive,
          },
        );

  final Map<DashBumperId, DashBumperSpriteState> bumperSpriteStates;

  bool get isFullyActivated => bumperSpriteStates.values
      .every((spriteState) => spriteState == DashBumperSpriteState.active);

  @override
  List<Object> get props => [...bumperSpriteStates.values];
}
