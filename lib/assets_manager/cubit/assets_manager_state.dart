part of 'assets_manager_cubit.dart';

/// {@template assets_manager_state}
/// State used to load the game assets.
/// {@endtemplate}
class AssetsManagerState extends Equatable {
  /// {@macro assets_manager_state}
  const AssetsManagerState({
    required this.assetsCount,
    required this.loaded,
  });

  /// {@macro assets_manager_state}
  const AssetsManagerState.initial() : this(assetsCount: 0, loaded: 0);

  /// Number of assets to load.
  final int assetsCount;

  /// Number of already loaded assets.
  final int loaded;

  /// Returns a value between 0 and 1 to indicate the loading progress.
  double get progress => loaded == 0 ? 0 : loaded / assetsCount;

  /// Only returns false if all the assets have been loaded.
  bool get isLoading => progress != 1;

  /// Returns a copy of this instance with the given parameters
  /// updated.
  AssetsManagerState copyWith({
    int? assetsCount,
    int? loaded,
  }) {
    return AssetsManagerState(
      assetsCount: assetsCount ?? this.assetsCount,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object> get props => [loaded, assetsCount];
}
