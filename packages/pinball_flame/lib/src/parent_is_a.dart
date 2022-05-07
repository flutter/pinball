import 'package:flame/components.dart';

/// A mixin that ensures a parent is of the given type [T].
mixin ParentIsA<T extends Component> on Component {
  @override
  T get parent => super.parent! as T;

  @override
  Future<void>? addToParent(covariant T parent) {
    return super.addToParent(parent);
  }
}
