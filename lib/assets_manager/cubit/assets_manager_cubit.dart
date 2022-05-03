import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'assets_manager_state.dart';

/// {@template assets_manager_cubit}
/// Cubit responsable for pre loading any game assets
/// {@endtemplate}
class AssetsManagerCubit extends Cubit<AssetsManagerState> {
  /// {@macro assets_manager_cubit}
  AssetsManagerCubit(List<Future> loadables)
      : super(
          AssetsManagerState.initial(
            loadables: loadables,
          ),
        );

  /// Loads the assets
  Future<void> load() async {
    final all = state.loadables.map((loadable) async {
      await loadable;
      emit(state.copyWith(loaded: [...state.loaded, loadable]));
    }).toList();

    await Future.wait(all);
  }
}
