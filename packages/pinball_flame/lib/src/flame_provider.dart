// ignore_for_file: public_member_api_docs

import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

class FlameProvider<T> extends Component {
  FlameProvider.value(
    this.provider, {
    Iterable<Component>? children,
  }) : super(
          children: children,
        );

  final T provider;
}

class MultiFlameProvider extends Component {
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

extension ReadFlameProvider on Component {
  T readProvider<T>() {
    final providers = ancestors().whereType<FlameProvider<T>>();
    assert(
      providers.isNotEmpty,
      'No FlameProvider<$T> available on the component tree',
    );

    return providers.first.provider;
  }
}

extension ReadFlameBlocProvider on Component {
  B readBloc<B extends BlocBase<S>, S>() {
    final providers = ancestors().whereType<FlameBlocProvider<B, S>>();
    assert(
      providers.isNotEmpty,
      'No FlameBlocProvider<$B, $S> available on the component tree',
    );

    return providers.first.bloc;
  }
}
