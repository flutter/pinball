import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

/// {@template component_controller}
/// A [ComponentController] is a [Component] in charge of handling the logic
/// associated with another [Component].
/// {@endtemplate}
abstract class ComponentController<T extends Component> extends Component {
  /// {@macro component_controller}
  ComponentController(this.component);

  /// The [Component] controlled by this [ComponentController].
  final T component;

  @override
  Future<void> addToParent(Component parent) async {
    assert(
      parent == component,
      'ComponentController should be child of $component.',
    );
    await super.addToParent(parent);
  }

  @override
  Future<void> add(Component component) {
    throw Exception('ComponentController cannot add other components.');
  }
}

/// Mixin that attaches a single [ComponentController] to a [Component].
mixin Controls<T extends ComponentController> on Component {
  /// The [ComponentController] attached to this [Component].
  late T controller;

  @override
  @mustCallSuper
  Future<void> onLoad() async {
    await super.onLoad();
    await add(controller);
  }
}
