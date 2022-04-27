// ignore_for_file: public_member_api_docs

part of 'flutter_forest_cubit.dart';

class FlutterForestState extends Equatable {
  const FlutterForestState({
    required this.activatedBumpers,
  });

  const FlutterForestState.initial() : this(activatedBumpers: const {});

  final Set<DashNestBumper> activatedBumpers;

  bool get hasBonus => activatedBumpers.length == 3;

  FlutterForestState copyWith({
    Set<DashNestBumper>? activatedBumpers,
  }) {
    return FlutterForestState(
      activatedBumpers: activatedBumpers ?? this.activatedBumpers,
    );
  }

  @override
  List<Object> get props => [activatedBumpers];
}
