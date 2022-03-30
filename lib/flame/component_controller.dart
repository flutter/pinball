import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';

/// {@template component_controller}
/// A [ComponentController] is a [Component] in charge of handling the logic
/// associated with another [Component].
///
/// [ComponentController]s usually implement [BlocComponent].
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
      'ComponentController should be child of $component. '
      'Use attach() instead.',
    );
    await super.addToParent(parent);
  }

  /// Ads the [ComponentController] to its [component].
  Future<void> attach() async {
    if (parent == null) await component.add(this);
  }
}
