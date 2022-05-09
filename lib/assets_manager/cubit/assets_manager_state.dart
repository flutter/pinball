part of 'assets_manager_cubit.dart';

/// {@template assets_manager_state}
/// State used to load the game assets
/// {@endtemplate}
class AssetsManagerState extends Equatable {
  /// {@macro assets_manager_state}
  const AssetsManagerState({
    required this.loadables,
    required this.loaded,
    this.error,
  });

  /// {@macro assets_manager_state}
  const AssetsManagerState.initial()
      : this(loadables: const [], loaded: const []);

  /// List of futures to load
  final List<Future> loadables;

  /// List of loaded futures
  final List<Future> loaded;

  final String? error;

  /// Returns a value between 0 and 1 to indicate the loading progress
  double get progress =>
      loadables.isEmpty ? 0 : loaded.length / loadables.length;

  /// Only returns false if all the assets have been loaded
  bool get isLoading => progress != 1 && error == null;

  /// Returns a copy of this instance with the given parameters
  /// updated
  AssetsManagerState copyWith({
    List<Future>? loadables,
    List<Future>? loaded,
    String? error,
  }) {
    return AssetsManagerState(
      loadables: loadables ?? this.loadables,
      loaded: loaded ?? this.loaded,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [loaded, loadables];
}
