import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

/// {@template flame_provider}
/// Provider-style component, similar to Provider in Flutter, but used to
/// retrieve [Component] objects previously provided
/// {@endtemplate}
class FlameProvider<T> extends Component {
  //// {@macro flame_provider}
  FlameProvider.value(
    this.provider, {
    Iterable<Component>? children,
  }) : super(children: children);

  /// The object that needs to be provided
  final T provider;
}

//// {@template multi_flame_provider}
/// MultiProvider-style component, similar to MultiProvider in Flutter,
/// but used to retrieve more than one [Component] object previously provided
/// {@endtemplate}
class MultiFlameProvider extends Component {
  /// {@macro multi_flame_provider}
  MultiFlameProvider({
    required List<FlameProvider<dynamic>> providers,
    Iterable<Component>? children,
  })  : _providers = providers,
        _initialChildren = children,
        assert(providers.isNotEmpty, 'At least one provider must be given') {
    _addProviders();
  }

  final List<FlameProvider<dynamic>> _providers;
  final Iterable<Component>? _initialChildren;
  FlameProvider<dynamic>? _lastProvider;

  Future<void> _addProviders() async {
    final _list = [..._providers];

    var current = _list.removeAt(0);
    while (_list.isNotEmpty) {
      final provider = _list.removeAt(0);
      await current.add(provider);
      current = provider;
    }

    await add(_providers.first);
    _lastProvider = current;

    _initialChildren?.forEach(add);
  }

  @override
  Future<void> add(Component component) async {
    if (_lastProvider == null) {
      await super.add(component);
    }
    await _lastProvider?.add(component);
  }
}

/// Extended API on [Component]
extension ReadFlameProvider on Component {
  /// Retrieve an object of type [T] that was previously provided
  T readProvider<T>() {
    final providers = ancestors().whereType<FlameProvider<T>>();
    assert(
      providers.isNotEmpty,
      'No FlameProvider<$T> available on the component tree',
    );

    return providers.first.provider;
  }

  /// Retrieve a bloc [B] with state [S] previously provided
  B readBloc<B extends BlocBase<S>, S>() {
    final providers = ancestors().whereType<FlameBlocProvider<B, S>>();
    assert(
      providers.isNotEmpty,
      'No FlameBlocProvider<$B, $S> available on the component tree',
    );

    return providers.first.bloc;
  }
}
